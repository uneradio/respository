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

class GroupDecorator
	attr_accessor :decorator, :group

	def initialize decorator
		@decorator = decorator
	end

	def decorate group
		@decorator.decorate group
	end

end

class CompositeGroupDecorator < GroupDecorator
	attr_accessor :childs

	def initialize
		@childs = []
	end

	def add group_decorator
		@childs << group_decorator
	end

	def decorate group
		@childs.each do |child|
			child.decorate group
		end
	end
end

class CountGroupDecorator < GroupDecorator
	attr_accessor :name

	def initialize name, field=1
		@name = name
		@field = field
	end

	def decorate group
		group["$group"].merge!({@name => {"$sum" => @field}})
	end
end

class AvgGroupDecorator < GroupDecorator
	attr_accessor :name

	def initialize name, field="$seconds_connected"
		@name = name
		@field = field
	end

	def decorate group
		group["$group"].merge!({name => {"$avg" => @field}})
	end
end
