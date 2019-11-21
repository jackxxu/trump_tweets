
require 'pry'
require_relative 'block.rb'
file_nm = 'market/Settlements/1_2_2017_ags_settlements.txt'

LINES_TO_SKIP = ['TOTAL', 'END OF REPORT', '---- DAILY ---', 'STRIKE     OPEN']

securities = []

File.open("data.csv", "w") do |output|
  output.puts 'file_nm,strike_dt,open,high,low,last,settled,change,vol,prev_settled,prev_vol,pre_int'
  # input_lines = File.readlines(file_nm)  
  # security_lines = input_lines.each_with_index.select { |row, index| !row.include?('  ') }.map(&:last)
  File.readlines(file_nm).drop(1).each do |line|
    line = line.rstrip
    next if LINES_TO_SKIP.any? {|part| line.include?(part)}
    if !line.include?('  ')
      securities << Block.new(line) 
    else 
      securities.last << line
    end
  end
end

binding.pry
securities