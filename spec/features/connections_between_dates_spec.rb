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
require 'spec_helper'

feature "connections between dates" do
#   background do
#     admin = FactoryGirl.create(:admin)
#     2.times do
#         FactoryGirl.create(:connection_on_Jan_2014)
#     end
#     FactoryGirl.create(:connection_on_Feb_2014)
#     FactoryGirl.create(:connection_on_Mar_2014)
#     FactoryGirl.create(:connection_on_Jan_2015)
#   end
  
#   def log_in_process 
#     visit "/"
#     within '#buttonLogin' do
#       click_button 'Login'
#     end
#     within '#modalLogin' do
#       fill_in 'Login', :with => 'admin'
#       fill_in 'Password', :with => 'admin'
#       click_button 'Login'
#     end
#   end

#   def assert_initial_state
#     log_in_process
#     visit "/home#/stats"
#     page.should have_content("No existen datos para estas fechas")
#     page.should_not have_content("Fechas inválidas")
#   end

#   def assert_end_date_long_time_ago
#     fill_in 'fechaFin', :with => Date.new(2010,1,1)
#     page.should_not have_content("No existen datos para estas fechas")
#     page.should have_content("Fechas inválidas")
#   end

#   scenario "group results by year", :js => true do
#     assert_initial_state
#     fill_in 'fechaIni', :with => Date.new(2013,1,1)

#     click_button 'Year'
#     page.text.should match("2014")
#     page.text.should match("2015")

#     assert_end_date_long_time_ago
#   end
  
#   scenario "group results by month", :js => true do
#     assert_initial_state
#     fill_in 'fechaIni', :with => Date.new(2013,1,1)
    
#     click_button 'Month'
#     page.text.should match("1/2014")
#     page.text.should match("2/2014")
#     page.text.should match("3/2014")
#     page.text.should match("1/2015")

#     assert_end_date_long_time_ago
#   end

# # #     page.text.should match("/\A.*1\/2014.*\z/")
# #     #page.text.should match("\A.*2\/2014.*\z")
# #     #page.text.should match("\A.*3\/2014.*\z")
# #     #page.text.should match("\A.*1\/2015.*\z")

# #     # select '25/03/2013', :from => 'fechaFin'
# #     # page.should have_content("01/2013")
# #     # page.should have_content("02/2013")
# #     # page.should have_content("03/2013")
# #     # page.should_not have_content("01/2014")
# # #     
# #     # select '02/02/2013', :from => 'fechaIni'
# #     # page.should_not have_content("01/2013")
# #     # page.should have_content("02/2013")
# #     # page.should have_content("03/2013")
# #     # page.should_not have_content("01/2014")
# # #     
# #     # click_button 'Year'
# #     # page.should have_content("2013")
# #     # page.should_not have_content("2014")
    
# #     # click_button 'Day'
# #     # page.should have_content("01/01/2013")
# #     # page.should have_content("18/01/2013")
# #     # page.should have_content("02/02/2013")
# #     # page.should have_content("15/12/2013")
# #     # page.should have_content("01/01/2014")
  
end
