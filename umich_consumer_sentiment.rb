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
  puts "source_code: UMICH"
  puts "code: SOC#{table_number}"
  puts "name: University of Michigan Consumer Survey,#{title}"
  puts "description: |\n  Reproduced with Permission.  Publisher's terms of use at www.sca.isr.umich.edu/agreement.php\n  Data points for the most recent 6 months are unofficial; they are sourced from articles in the Wall Street Journal.\n  The script that produces this dataset can be found at https://github.com/tammer/scrapers/blob/master/umich_consumer_sentiment.rb"
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

1.upto(47) do |i|
	process_table(i,1977)
end
