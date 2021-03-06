=begin
IceCast-Stats is system for statistics generation and analysis
for an IceCast streaming server
Copyright (C) 2015  René Balay Lorenzo <rene.bl89@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
=end

require 'rails_helper'
require 'json'

RSpec.describe ConnectionsController, type: :controller do
  
  describe "when admin not authenticated" do
    it "should redirect to login form page" do
      xhr :get, :ranges, :start_date => '01/01/2014', :end_date => '01/01/2014', :unique_visitors => 'true',
        :min => 5, :max => 10, :format => :json
      expect(response).to redirect_to(login_form_path)
      
      # xhr :get, :years, :format => :json
      # expect(response).to redirect_to(login_form_path)
      
      # xhr :get, :index, :format => :json
      # expect(response).to redirect_to(login_form_path)
      
      # xhr :get, :months, :year => 2014, :format => :json
      # expect(response).to redirect_to(login_form_path)
    end
  end
  
  describe "when pass two dates grouped by year" do
    before(:each) do
      2.times do
        FactoryGirl.create(:connection_on_Jan_2014)
      end
      
      FactoryGirl.create(:connection_on_Feb_2014)
      FactoryGirl.create(:connection_on_Mar_2014)
      FactoryGirl.create(:connection_on_2015)     
      
      admin = FactoryGirl.create(:admin)
      log_in(admin)
    end
    
    it "should return 4 connections in 2014" do
      connections_between_dates_year_array = [
        { :_id => { :year => 2014 }, :count => 4 }
      ]
      connections_between_dates_year = connections_between_dates_year_array.to_json
      xhrRequestConnBetweenDates connections_between_dates_year, '01/01/2014', '25/03/2014'
      xhrRequestConnBetweenDates connections_between_dates_year, '18/01/2014', '28/03/2014'
    end
    
    it "should return unique visitors in 2014" do
      connections_between_dates_year_array = [
        { :_id => { :year => 2014 }, :count => 3 }
      ]
      connections_between_dates_year = connections_between_dates_year_array.to_json
      xhrRequestConnBetweenDates connections_between_dates_year, '01/01/2014', '25/03/2014', 'year', 'true'
    end
    
    it "should return 2 connections in 2014" do 
      connections_between_dates_year_array = [
        { :_id => { :year => 2014 }, :count => 2 }
      ]
      connections_between_dates_year = connections_between_dates_year_array.to_json
      xhrRequestConnBetweenDates connections_between_dates_year, '19/01/2014', '25/03/2014'
      
      connections_between_dates_year_array = [
        { :_id => { :year => 2014 }, :count => 3 }
      ]
      connections_between_dates_year = connections_between_dates_year_array.to_json
      xhrRequestConnBetweenDates connections_between_dates_year, '01/01/2014', '24/03/2014'
    end
    
    it "should return 5 connections: 2014 and 2015" do 
      connections_between_dates_year_array = [
        { :_id => { :year => 2014 }, :count => 4 },
        { :_id => { :year => 2015 }, :count => 1 }
      ]
      connections_between_dates_year = connections_between_dates_year_array.to_json
      xhrRequestConnBetweenDates connections_between_dates_year, '01/01/2014', '02/08/2015'
    end
  end
  
  describe "when pass two dates grouped by month" do
    before(:each) do
      2.times do
        FactoryGirl.create(:connection_on_Jan_2014)
      end
      
      FactoryGirl.create(:connection_on_Feb_2014)
      FactoryGirl.create(:connection_on_Jan_2015)
      
      admin = FactoryGirl.create(:admin)
      log_in(admin)
    end
    
    it "should return 2 connections on January and in February of 2014" do
      connections_between_dates_month_array = [
        { :_id => { :year => 2014, :month => 1}, :count => 2},
        { :_id => { :year => 2014, :month => 2}, :count => 1}
      ]
      connections_between_dates_month = connections_between_dates_month_array.to_json
      xhrRequestConnBetweenDates connections_between_dates_month, '01/01/2014', '20/02/2014', 'month'
    end
    
    it "should return unique visitors in January and February 2014" do
      connections_between_dates_month_array = [
        { :_id => { :year => 2014, :month => 1}, :count => 1},
        { :_id => { :year => 2014, :month => 2}, :count => 1}
      ]
      connections_between_dates_month = connections_between_dates_month_array.to_json
      xhrRequestConnBetweenDates connections_between_dates_month, '01/01/2014', '25/03/2014', 'month', 'true'
    end
    
    it "should return 2 connections on January, 1 in February of 2014, and 1 in January of 2015" do
      connections_between_dates_month_array = [
        { :_id => { :year => 2014, :month => 1}, :count => 2},
        { :_id => { :year => 2014, :month => 2}, :count => 1},
        { :_id => { :year => 2015, :month => 1}, :count => 1}
      ]
      connections_between_dates_month = connections_between_dates_month_array.to_json
      xhrRequestConnBetweenDates connections_between_dates_month, '03/01/2014', '01/01/2015', 'month'
    end
  end
  
  describe "when pass two dates grouped by day" do
    before(:each) do
      2.times do
        FactoryGirl.create(:connection_on_Jan_2014)
        FactoryGirl.create(:connection_on_Feb_2014)
      end
      FactoryGirl.create(:connection_on_Mar_2014)
      FactoryGirl.create(:connection_on_Jan_2015)
      
      admin = FactoryGirl.create(:admin)
      log_in(admin)
    end
    
    it "should return 2 connections on 18/01/2014, 2 on 19/02/2014, and 1 in 25/03/2014" do
      connections_between_dates_day_array = [
        { :_id => { :year => 2014, :month => 1, :day => 18}, :count => 2},
        { :_id => { :year => 2014, :month => 2, :day => 19 }, :count => 2},
        { :_id => { :year => 2014, :month => 3, :day => 25 }, :count => 1}
      ]
      connections_between_dates_day = connections_between_dates_day_array.to_json
      xhrRequestConnBetweenDates connections_between_dates_day, '18/01/2014', '25/03/2014', 'day'
    end
    
    it "should return unique visitors between 18/01/2014 and 25/03/2014" do
      connections_between_dates_day_array = [
        { :_id => { :year => 2014, :month => 1, :day => 18 }, :count => 1},
        { :_id => { :year => 2014, :month => 2, :day => 19 }, :count => 1},
        { :_id => { :year => 2014, :month => 3, :day => 25 }, :count => 1}
      ]
      connections_between_dates_day = connections_between_dates_day_array.to_json
      xhrRequestConnBetweenDates connections_between_dates_day, '18/01/2014', '25/03/2014', 'day', 'true'
    end
    
    it "should return 2 connections on 18/01/2014, 2 on 19/02/2014, 1 on 25/03/2014 and 1 on 01/01/2015" do
      connections_between_dates_day_array = [
        { :_id => { :year => 2014, :month => 1, :day => 18 }, :count => 2},
        { :_id => { :year => 2014, :month => 2, :day => 19 }, :count => 2},
        { :_id => { :year => 2014, :month => 3, :day => 25 }, :count => 1},
        { :_id => { :year => 2015, :month => 1, :day => 01 }, :count => 1}
      ]
      connections_between_dates_day = connections_between_dates_day_array.to_json
      xhrRequestConnBetweenDates connections_between_dates_day, '18/01/2014', '01/01/2015', 'day'
    end
  end
  
  describe "when pass invalid data" do
    before(:each) do    
      admin = FactoryGirl.create(:admin)
      log_in(admin)
      
      errorDateHash = {"error" => "One date is invalid. Correct format: d/m/Y"}
      @errorDate = errorDateHash.to_json
      
      errorGroupHash = {"error" => "Invalid group by option: try year, month or day"}
      @errorGroup = errorGroupHash.to_json
    end
    
    it "should return invalid date format errors in JSON" do
      xhrRequestConnBetweenDates @errorDate, '18/01/2014/', '010/01/2015'
      xhrRequestConnBetweenDates @errorDate, '01/18/2014', '01/01/2015'
      xhrRequestConnBetweenDates @errorDate, '18/01/2014', '2014/01/03'
    end
    
    it "should return invalid group by option errors in JSON" do
      xhrRequestConnBetweenDates @errorGroup, '18/01/2014', '01/01/2015', " "
      xhrRequestConnBetweenDates @errorGroup, '18/01/2014', '01/01/2015', "true", "fake"
      expect(response.body).to eql(@errorGroup)
    end
    
  end
  
  def xhrRequestConnBetweenDates(expected, st_date='18/01/2014', end_date='01/01/2015', group_by='year', unique='false')
    xhr :get, :connections_between_dates, :start_date => st_date, :end_date => end_date, :unique_visitors => unique,
     :group_by => group_by, :format => :json
    expect(response.body).to eql(expected)
  end

  describe "when access to connections range of duration" do
    before(:each) do
      2.times do
        FactoryGirl.create(:connection_with_5_seconds)
      end
      
      FactoryGirl.create(:connection_with_20_seconds)
      FactoryGirl.create(:connection_with_30_seconds)
      FactoryGirl.create(:connection_with_60_seconds)
      FactoryGirl.create(:connection_with_120_seconds)
      FactoryGirl.create(:connection_with_200_seconds)
      
      admin = FactoryGirl.create(:admin)
      log_in(admin)
    end

    it "should return connections filtered by seconds of connection" do
      ranges_array = [
        { :_id => "A: <= 5", :count => 2},
        { :_id => "B: 5-120", :count => 4},
        { :_id => "C: > 120", :count => 1}
      ]
      xhrRequestConnRanges(ranges_array)

      ranges_array = [
        { :_id => "A: <= 5", :count => 1},
        { :_id => "B: 5-120", :count => 4},
        { :_id => "C: > 120", :count => 1}
      ]
      xhrRequestConnRanges(ranges_array, 5, 120, 'true')

      ranges_array = [
        { :_id => "A: <= 20", :count => 3},
        { :_id => "B: 20-60", :count => 2},
        { :_id => "C: > 60", :count => 2}
      ]
      xhrRequestConnRanges(ranges_array, 20, 60) 

      ranges_array = [
        { :_id => "A: <= 20", :count => 2},
        { :_id => "B: 20-30", :count => 1},
        { :_id => "C: > 30", :count => 3}
      ]
      xhrRequestConnRanges(ranges_array, 20, 30, 'true')

      ranges_array = [
        { :_id => "A: <= 7", :count => 2},
        { :_id => "B: 7-200", :count => 5}
      ]
      xhrRequestConnRanges(ranges_array, 7, 200)

      ranges_array = [
        { :_id => "A: <= 20", :count => 3},
        { :_id => "C: > 20", :count => 4}
      ]
      xhrRequestConnRanges(ranges_array, 20, 20)

      ranges_array = { "error" => "Rango no válido (min <= max | min && max not null | min && max >= 0)" }
      xhrRequestConnRanges(ranges_array, 30, 5)

      ranges_array = { "error" => "Rango no válido (min <= max | min && max not null | min && max >= 0)" }
      xhrRequestConnRanges(ranges_array, 0, -1)

      ranges_array = { "error" => "Rango no válido (min <= max | min && max not null | min && max >= 0)" }
      xhrRequestConnRanges(ranges_array, -1, 0)

      ranges_array = { "error" => "Rango no válido (min <= max | min && max not null | min && max >= 0)" }
      xhrRequestConnRanges(ranges_array, -1, -1)

    end

    def xhrRequestConnRanges(expected_array, min=5, max=120, unique='false', st_date='18/01/2014', end_date='01/01/2015')
      expected = expected_array.to_json
      xhr :get, :ranges, :start_date => st_date, :end_date => end_date, :unique_visitors => unique,
        :min => min, :max => max, :format => :json
      expect(response.body).to eql(expected)
    end
  end

  describe "when access to total number of connections seconds" do

    before(:each) do
      2.times do
        FactoryGirl.create(:connection_with_5_seconds)
      end
      
      FactoryGirl.create(:connection_with_20_seconds)
      FactoryGirl.create(:connection_with_30_seconds)
      FactoryGirl.create(:connection_with_60_seconds)
      FactoryGirl.create(:connection_with_120_seconds)
      FactoryGirl.create(:connection_with_200_seconds)
      
      admin = FactoryGirl.create(:admin)
      log_in(admin)
    end

    it "should return a number representing total amount of seconds in a period" do
      total_time_array = [
        { :_id => "total", :count => 440 }
      ]
      xhrRequestTotalTime total_time_array

      total_time_array = [
        { :_id => "total", :count => 410 }
      ]
      xhrRequestTotalTime total_time_array, '15/04/2014'

      total_time_array = [
        { :_id => "total", :count => 120 }
      ]
      xhrRequestTotalTime total_time_array, '25/03/2014', '09/10/2014'

    end

    def xhrRequestTotalTime(expected_array, st_date='25/03/2014', end_date='01/01/2015')
      expected = expected_array.to_json
      xhr :get, :total_seconds, :start_date => st_date, :end_date => end_date, :format => :json
      expect(response.body).to eql(expected)
    end
  end

  describe "when access to avg number of connections seconds" do

    before(:each) do
      2.times do
        FactoryGirl.create(:connection_with_5_seconds)
      end
      
      FactoryGirl.create(:connection_with_20_seconds)
      FactoryGirl.create(:connection_with_30_seconds)
      FactoryGirl.create(:connection_with_60_seconds)
      FactoryGirl.create(:connection_with_120_seconds)
      FactoryGirl.create(:connection_with_200_seconds)
      
      admin = FactoryGirl.create(:admin)
      log_in(admin)
    end

    it "should return a number representing avg amount of seconds in a period" do
      total_time_array = [
        { :_id => "avg", :count => 62.857142857142854 }
      ]
      xhrRequestAvgTime total_time_array

      total_time_array = [
        { :_id => "avg", :count => 86.0 }
      ]
      xhrRequestAvgTime total_time_array, '05/04/2014'

      total_time_array = [
        { :_id => "avg", :count => 24.0 }
      ]
      xhrRequestAvgTime total_time_array, '25/03/2014', '09/10/2014'

    end

    def xhrRequestAvgTime(expected_array, st_date='25/03/2014', end_date='01/01/2015')
      expected = expected_array.to_json
      xhr :get, :avg_seconds, :start_date => st_date, :end_date => end_date, :format => :json
      expect(response.body).to eql(expected)
    end
  end

end
