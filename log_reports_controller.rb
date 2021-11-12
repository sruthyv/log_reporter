# Analyse webserver.log
require 'pry'
require_relative 'services/data_parser'

class LogReportsController
  def initialize(file_name:)
    @file_name = file_name
  end

  def index
    return "No log file name provided" if @file_name.nil?

    DataParser.new(log_file: @file_name).call
  end
end

LogReportsController.new(file_name: ARGV[0]).index