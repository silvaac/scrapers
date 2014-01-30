require "nokogiri"
require 'open-uri'


#
# Shibor, last 10 days
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
	print row.shift.content
	row.each do |item|
		print ", #{item.content}"
	end
	puts
end



