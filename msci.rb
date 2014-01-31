require "nokogiri"
require 'open-uri'

#
# This script prints the MSCI Far East Index to STDOUT
#

puts <<META
code: MSCI_FAREAST
name: MSCI Far East Index
description: MSCI Far East Index in USD since 1969
reference_url: www.msci.com/products/indices/performance.html
private: true
--
Date,Value
META

index = 114 # Far East Index
frequency = 'M' # monthly
ccy = 15 # USD

url = "http://www.msci.com/webapp/indexperf/charts?indices=#{index},C,36&startDate=29%20Jan,%201960&endDate=29%20Jan,%202024&priceLevel=0&currency=#{ccy}&frequency=#{frequency}&scope=&format=XML&baseValue=false&site=gimi"

doc = Nokogiri::XML(open(url))

doc.xpath('performance/index/asOf').each do |row|
  puts "#{row.xpath('date').text}, #{row.xpath('value').text.gsub(',','')}"
end
