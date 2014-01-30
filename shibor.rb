require "nokogiri"
require 'open-uri'

#
# Print the last 10 days of Shibor in Quandl data format
#

puts <<META
code: SHIBOR
name: Shibor
description: Shaghai Interbank Offer Rate
reference_url: http://www.shibor.org/shibor/web/AllShibor_e.jsp
--
META

doc = Nokogiri::HTML(open('http://www.shibor.org/shibor/ShiborTendaysShow_e.do'))

doc.css('#result tr').each do |row|
	row = row.css('td')
	puts row.map {|datum| datum.content }.join(", ")
end



