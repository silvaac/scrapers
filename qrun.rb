#!/usr/bin/env ruby
require 'open3'
require 'optparse'

def sendMail (body)
  Open3.capture3("mail -s #{ARGV[0]} #{@EMAIL}", :stdin_data => body)
end
@EMAIL = 'tammer@tammer.com'

begin
  @QUANDL_CMD = `which quandl`.strip

  if @QUANDL_CMD == ''
    @QUANDL_CMD = '/usr/local/quandl/bin/quandl'
  end


  # Parse command line

  options = {}
  OptionParser.new do |opts|
    opts.on("-v", "--verbose", "include output of scraper in the email report") do |v|
      options[:verbose] = v
    end
    opts.on("-s", "--silent", "Report ONLY errors and nothing else; supercedes -v option") do |s|
      options[:silent] = s
    end
    opts.on("-m", "--email [EMAIL]", "Report ONLY errors and nothing else; supercedes -v option") do |e|
      @EMAIL = e
    end
  end.parse!

  # Run the scraper:
  stdout1,stderr1,status = Open3.capture3("ruby #{ARGV[0]}")

  # unless stderr1 == ''
  #   puts stderr1
  #   sendMail(stderr1)
  #   exit
  # end

  # puts "Scraper sent nothing to stderr. so now piping stdout to quandl upload"

  stdout2, stderr2, status = Open3.capture3("#{@QUANDL_CMD} upload", :stdin_data => stdout1)

  final_report = "Scheduled Run of:  #{ARGV[0]}\n\n"

  final_report << "Scraper Errors:"
  if stderr1 == ''
    final_report << "  none\n\n"
  else
    final_report << "\n\n#{stderr1}\n\n"
  end

  if options[:verbose]
    final_report << "Scraper Output:"
    final_report << "\n\n#{stdout1}\n\n"
  end

  final_report << "Upload Errors:"
  if stderr2 == ''
    final_report << "  none\n\n"
  else
    final_report << "\n\n#{stderr2}\n\n"
  end

  unless options[:silent]
    final_report << "Upload results:"
    if stdout2 == ''
      final_report << "  Nothing Uploaded"
    else
      final_report << "\n\n#{stdout2}\n\n"
    end
  end


  puts final_report
  sendMail(final_report)

rescue
  puts "qrun itself has failed with #{$!}"
  Open3.capture3("mail -s 'qrun failed on #{ARGV[0]}' #{@EMAIL}", :stdin_data => "#{$!}")
end


