#!/usr/bin/env ruby

require 'open3'

def sendMail (body)
  Open3.capture3("mail -s #{ARGV[0]} tammer@tammer.com", :stdin_data => body)
end

# Run the scraper:
stdout,stderr,status = Open3.capture3("ruby #{ARGV[0]}")

unless stderr == ''
  puts stderr
  sendMail(stderr)
  exit
end

puts "Scraper sent nothing to stderr. so now piping stdout to quandl upload"

puts stdout

stdout, stderr, status = Open3.capture3("quandl upload", :stdin_data => stdout)

puts stdout + stderr
sendMail(stdout + stderr)

