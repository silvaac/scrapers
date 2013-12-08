#!/usr/bin/env ruby

require 'open3'
require 'optparse'

def sendMail (body)
  Open3.capture3("mail -s #{ARGV[0]} tammer@tammer.com", :stdin_data => body)
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
end.parse!

# Run the scraper:
stdout1,stderr1,status = Open3.capture3("ruby #{ARGV[0]}")

unless stderr1 == ''
  puts stderr1
  sendMail(stderr1)
  exit
end

puts "Scraper sent nothing to stderr. so now piping stdout to quandl upload"

puts stdout1

stdout2, stderr2, status = Open3.capture3("quandl upload", :stdin_data => stdout1)

puts stdout2 + stderr2

if options[:silent]
  if stderr2 == ''
    sendMail("No errors reported")
  else
    sendMail(stderr2)
  end
elsif options[:verbose]
  sendMail(stdout1 + stdout2 + stderr2)
else
  sendMail(stdout2 + stderr2)
end

