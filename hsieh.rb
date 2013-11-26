# This script converts David Hsieh's hedge fund factor spreadsheet into a csv
# David's data is here:  https://faculty.fuqua.duke.edu/~dah7/HFRFData.htm

require "spreadsheet"
require 'open-uri'
require 'date'

metadata = <<META
code: TFRF
name: Hsieh Trend-Following Hedge Fund Risk Factors
reference_url: www.thestar.com
description: |
  These trend-following factors are constructed based on the article by William Fung & David A. Hsieh, "The Risk in Hedge Fund Strategies: Theory and Evidence from Trend Followers," Review of Financial Studies, 14 (2001), 313-341.
  PTFSBD: Return of PTFS Bond lookback straddle
  PTFSFX: Return of PTFS Currency Lookback Straddle
  PTFSCOM:Return of PTFS Commodity Lookback Straddle
  PTFSIR: Return of PTFS Short Term Interest Rate Lookback Straddle
  PTFSSTK:Return of PTFS Stock Index Lookback Straddle
  Rules for the use of this data:
  1) You must cite Fung and Hsieh (RFS, 2001) in working papers and published papers that use any of these data.
  2) You must place the following URL in a footnote to help others find the data: http://faculty.fuqua.duke.edu/~dah7/DataLibrary/TF-FAC.xls
  3) You assume all risk for the use of the data.

  The script that produces this dataset can be found at https://github.com/tammer/scrapers
--
META

# reference_url: https://faculty.fuqua.duke.edu/~dah7/HFRFData.htm

temp = open("https://faculty.fuqua.duke.edu/~dah7/DataLibrary/TF-Fac.xls")
sheet = Spreadsheet.open(temp).worksheet(0)

puts metadata

puts "Date,PTFSBD,PTFSFX,PTFSCOM,PTFSIR,PTFSSTK"

0.upto(1200) do |i| # This script stops working in year 2112 ;-)
  begin
    dt = Date.new(sheet[i,0].to_s[0..3].to_i, sheet[i,0].to_s[4..5].to_i,1)
    dt = dt.next_month - 1 # end of month
    print dt
    1.upto(5) { |j| print ",#{sheet[i,j]}"}
    puts
  rescue
  end
  
end

