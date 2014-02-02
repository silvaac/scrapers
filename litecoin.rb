require "nokogiri"
require 'open-uri'

#
# Print the last 2 days of Litecoin v USD rates
#

puts <<META
code: LTC
name: Litecoin (LTC) vs US Dollar (USD)
description: Value of 1 Litecoin in US dollars.  Volume in units of LTC
reference_url: http://www.ltc-charts.com/period-charts.php?period=6-months&resolution=day&pair=ltc-usd&market=btc-e
--
META

doc = Nokogiri::HTML(open('http://www.ltc-charts.com/period-charts.php?period=2-days&resolution=day&pair=ltc-usd&market=btc-e'))

puts"Date,Low,High,Open,Close,Volume"
doc.css('.span10 table tr').each do |row|
	row = row.css('td')
	puts row.map {|datum| datum.content.gsub(',','') }.join(", ")
end



