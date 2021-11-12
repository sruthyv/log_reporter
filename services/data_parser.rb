class DataParser
  def initialize(log_file:)
    @log_file = log_file
    @single_path_logs = []
    @multi_level_path_logs = []
  end

  def call
    return "No contents are present in the file" if parse_log_file.empty?

    log_report
  end

  def log_report
    total_visits_log = parse_single_path_logs.merge(parse_multi_path_logs)
    log_report = []
    log_report << "List of webpages with most page views ordered from most pages views to less page views"
    log_report << "--------------------------------------------------------------------------------------\n"
    sort_by_desc(total_visits_log).each do |log|
      log_report<<  "#{green(log[0])} #{blue(log[1])} visits"
    end
    log_report << "\nList of webpages with most unique page views also ordered"
    log_report <<  "---------------------------------------------------------"
    total_uniq_visits_log = parse_single_uniq_path_logs.merge(parse_multi_uniq_path_logs)
    sort_by_desc(total_uniq_visits_log).each do |log|
      log_report << "#{green(log[0])} #{blue(log[1])} unique views"
    end
    puts log_report
    log_report
  end

  def parse_log_file
    log_aray = []
    File.open(@log_file).each do |line|
      log_aray << line
    end
    log_aray.each do |log|
      case log.split('/').length
      when 2
        @single_path_logs << log
      when 3
        @multi_level_path_logs << log
      end
    end
  rescue Errno::ENOENT => error
    error 
  end

  def parse_single_path_logs
    grouped_single_path_data = @single_path_logs.map do |log|
      log.split(' ')
    end
    single_views_log = Hash.new(0)
    group_by_hash(grouped_single_path_data).each do |name|
      single_views_log[name[0].split('/')[1]] = name[1].length
    end
    single_views_log
  end

  def parse_single_uniq_path_logs
    grouped_single_path_data = @single_path_logs.map do |log|
      log.split(' ')
    end
    single_uniq_views_log = Hash.new(0)
    group_by_hash(grouped_single_path_data).each do |name|
      single_uniq_views_log[name[0].split('/')[1]] = name[1].uniq.length
    end
    single_uniq_views_log
  end

  def parse_multi_path_logs
    grouped_multi_path_data = @multi_level_path_logs.map do |log|
      log.split(' ')
    end
    multi_views_log = Hash.new(0)
    group_by_hash(grouped_multi_path_data).each do |name|
      multi_views_log[name[0]] = name[1].length
    end
    multi_views_log
  end

  def parse_multi_uniq_path_logs
    grouped_multi_path_data = @multi_level_path_logs.map do |log|
      log.split(' ')
    end
    multi_uniq_views_log = Hash.new(0)
    group_by_hash(grouped_multi_path_data).each do |name|
      multi_uniq_views_log[name[0]] = name[1].uniq.length
    end
    multi_uniq_views_log
  end

  def group_by_hash(array)
    hash = {}
    array.each do |key, value|
      hash[key] ||= []
      hash[key] << value
    end
    hash
  end

  def sort_by_desc(log_views_by_path)
    sorted_array = log_views_by_path.sort_by do |log|
                      log[1]
                   end.reverse
    sorted_hash = {}
    sorted_array.each do |key, value|
      sorted_hash[key] = value
    end
    sorted_hash    
  end

  def green(str)
    "\e[32m#{str}\e[0m"
  end

  def blue(str)
    "\e[34m#{str}\e[0m"
  end
end
