# This script scrapes University of Michigan Consumer Sentiment data

require "net/http"
require "uri"
require 'date'

def process_table( table_number, start_year )
  uri = URI.parse("http://www.sca.isr.umich.edu/data-archive/mine.php")
  response = Net::HTTP.post_form(uri, {"table" => table_number,"year" => start_year, "format" => "Comma-Seperated (CSV)"})
  lines = response.body.split("\n")
  lines = response.body.gsub(/[,\s]+$/,'').split("\n")
  title = lines.shift.gsub(/.+:/,'').gsub(/The\s+/,'')
  puts "code: SOC#{table_number}"
  puts "name: University of Michigan Consumer Survey,#{title}"
  puts "description: Reproduced with Permission.  Publisher's terms of use at www.sca.isr.umich.edu/agreement.php\nData points more recent than 6 months come from the Wall Street Journal."
  puts "display_url: www.sca.isr.umich.edu/data-archive/mine.php"
  puts "--"
  headers = lines.shift.gsub("Month,Year","Date")
  puts headers
  lines.each do |line|
  	tokens = line.split(",")
  	dt = Date.new(tokens[1].to_i, tokens[0].to_i,1).next_month - 1
  	puts line.sub(/\d+,\d+/,dt.to_s)
  end
  puts

end


process_table(47,2007)