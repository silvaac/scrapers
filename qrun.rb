#!/usr/bin/env ruby

require 'open3'

def sendMail (body)
  Open3.capture3("mail -s #{ARGV[0]} tammer@tammer.com", :stdin_data => body)
end

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
sendMail(stdout1 + stdout2 + stderr2)

