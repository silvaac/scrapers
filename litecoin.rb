require "nokogiri"
require 'open-uri'

#
# Print the last 2 days of various crypto ccys
#

def dump_numbers(short_a, short_b)
  # period = "alltime"
  period = "2-days"
  doc = Nokogiri::HTML(open("http://www.cryptocoincharts.info/period-charts.php?period=#{period}&resolution=day&pair=#{short_a.downcase}-#{short_b.downcase}&market=btc-e"))
  print"Date,Low,High,Open,Close,Volume"
  doc.css('.span10 table tr').each do |row|
    row = row.css('td')
    puts row.map {|datum| datum.content.gsub(',','') }.join(", ")
  end
  puts;puts
end

def dump_meta( short_a, short_b, long_a, long_b )
  puts <<META
code: #{short_a}#{short_b}
name: #{long_a} (#{short_a}) vs #{long_b} (#{short_b}), BTC-e
description: Value of 1 #{long_a} in #{long_b}s.  Volume in units of #{short_a}.  Data from the BTC-e exchange.
reference_url: www.cryptocoincharts.info/period-charts.php?period=alltime&resolution=day&pair=#{short_a}-#{short_b}&market=btc-e
--
META
end

ccys = [
  ["LTC","BTC","Litecoin","Bitcoin"],
  ["LTC","USD","Litecoin","US Dollar"],
  ["BTC","USD","Bitcoin","US Dollar"],
]

ccys.each do |ccy|
  dump_meta(*ccy)
  dump_numbers(*ccy[0..1])
end



