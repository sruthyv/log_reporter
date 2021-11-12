# Request spec for people controller
require "test/unit"
require_relative 'log_reports_controller'

class LogReportsControllerTest < Test::Unit::TestCase
  def test_success_log_details
    expected_response = ["List of webpages with most page views ordered from most pages views to less page views",
      "--------------------------------------------------------------------------------------\n",
      "\e[32m/about/2\e[0m \e[34m90\e[0m visits",
      "\e[32mcontact\e[0m \e[34m89\e[0m visits",
      "\e[32mindex\e[0m \e[34m82\e[0m visits",
      "\e[32mabout\e[0m \e[34m81\e[0m visits",
      "\e[32m/help_page/1\e[0m \e[34m80\e[0m visits",
      "\e[32mhome\e[0m \e[34m78\e[0m visits",
      "\nList of webpages with most unique page views also ordered",
      "---------------------------------------------------------",
      "\e[32m/help_page/1\e[0m \e[34m23\e[0m unique views",
      "\e[32mindex\e[0m \e[34m23\e[0m unique views",
      "\e[32mhome\e[0m \e[34m23\e[0m unique views",
      "\e[32mcontact\e[0m \e[34m23\e[0m unique views",
      "\e[32m/about/2\e[0m \e[34m22\e[0m unique views",
      "\e[32mabout\e[0m \e[34m21\e[0m unique views"]
    generated_response = LogReportsController.new(file_name: 'webserver.log').index
    assert_equal expected_response, generated_response
  end

  def test_file_name_not_provided
    expected_response = "No log file name provided"
    generated_response = LogReportsController.new().index
    assert_equal expected_response, generated_response
  end

  def test_file_name_incorrect
    expected_response = "No such file or directory @ rb_sysopen - incorrect_name.log"
    generated_response = LogReportsController.new(file_name: 'incorrect_name.log').index
    assert_equal expected_response, generated_response
  end

  def test_file_has_no_content
    expected_response = "No contents are present in the file"
    generated_response = LogReportsController.new(file_name: 'no_content.log').index
    assert_equal expected_response, generated_response
  end
end