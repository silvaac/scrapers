# This script fetches SPX index data and prints to screen in QDF format

require "spreadsheet"
require 'open-uri'
require 'date'

metadata = <<META
code: SPX
name: S&P 500 Index and TR Index
reference_url: http://ca.spindices.com/indices/equity/sp-500
description: The S&P 500 Index.  Scraper that updates this dataset is here:  
--
META

puts metadata

temp = open("http://ca.spindices.com/idsexport/file.xls?selectedModule=PerformanceGraphView&selectedSubModule=Graph&yearFlag=fiveYearFlag&indexId=340")
sheet = Spreadsheet.open(temp).worksheet(0)

i=6

begin
  puts "#{sheet[i,0]}, #{sheet[i,1]}, #{sheet[i,2]}, #{sheet[i,3]}"
  i+=1
end until sheet[i,0].nil?
