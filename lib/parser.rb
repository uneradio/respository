require "#{Rails.root}/lib/exceptions/parserException"

module Parser

  def Parser.initialize_parser
    # Inicializa las variables necesarias para el parser. Dado que las constantes exponen el valor de estas
    # se utilizan variables de instancia para obtener ocultación y encapsulación de la información
    @config = YAML.load_file('config/parser_config.yml')
  end

  # Recorre las línes del fichero de log que se pasa como parámetro, por defecto el fichero de log del servidor
  # Además, obtiene el offset del fichero de configuración para obviar las líneas que ya han sido parseadas
  # Por último actualiza dicho fichero de configuración guardando el offset donde se ha quedado 
  def Parser.parse(path=@config['log_path'])
    begin
      if File.exists? path
        parser = ApacheLogRegex.new(@config['log_format'])
        f = File.open(path, 'r+')
        f.seek(@config['seek_pos'], :SET)
        line = f.gets
        while (line != nil) do
          result = parser.parse!(line)
          persist_line result
          line = f.gets
        end
      else
        Parser.write_log "Parser couldn't find file: #{path}"
        raise ParserException, "File not found"
      end 
    rescue ApacheLogRegex::ParseError => e
      Parser.write_log "Parser format exception #{e.message}"
      raise ParserException, "Formato incorrecto"
    ensure
      unless f == nil
        @config['seek_pos'] = f.tell
        File.open('config/parser_config.yml', 'w+') {|f| f.write @config.to_yaml }
      end
    end 
  end

  # Persiste una línea del fichero de log en la base de datos
  def Parser.persist_line(line)
    begin
      date = Parser.string_to_datetime line["%t"]
      cnt, reg, ct = Parser.get_geo_info line["%h"]
      Connection.create!(ip: line["%h"], identd: line["%l"], userid: line["%u"], datetime: date, request: line["%r"],
        status: line["%>s"], bytes: line["%b"], referrer: line["%{Referer}i"], user_agent: line["%{User-agent}i"],
        seconds_connected: line["(%{ratio}n)"], city: ct, region: reg, country: cnt)
    rescue Mongoid::Errors::Validations => e
       Parser.write_log "Invalid data parsing line #{e.message}"
       raise ParserException, "Datos inválidos"
    rescue NoMethodError => e
      Parser.write_log "Nil line #{e.message}"
      raise ParserException, "Linea nula"
    rescue ArgumentError => e
      Parser.write_log "Exception parsing date #{e.message}"
      raise ParserException, "Formato de fecha incorrecto"
    end
  end
  
  private
  def Parser.string_to_datetime str
    time = str
    date = DateTime.evolve(DateTime.strptime(time, "[%d/%b/%Y:%H:%M:%S %Z]"))
    date
  end
  
  def Parser.write_log message
    Rails.logger.warn message
  end
  
  def Parser.get_geo_info ip
    info = Rails.cache.fetch ip do
      solvedIp = Geocoder.search ip
      solvedIp
    end
    [info[0].data["country_name"], info[0].data["region_name"], info[0].data["city"]]
  end
end