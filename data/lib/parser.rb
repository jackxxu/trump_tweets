
require 'pry'
require_relative 'block.rb'
file_nm = 'market/Settlements/1_2_2017_ags_settlements.txt'

LINES_TO_SKIP = ['TOTAL', 'END OF REPORT', '---- DAILY ---', 'STRIKE     OPEN']

securities = []

File.open("data.csv", "w") do |output|
  output.puts (['file_nm', 'security'] + Line::RANGES.keys).join(',')

  File.readlines(file_nm).drop(1).each do |line|
    line = line.rstrip
    next if LINES_TO_SKIP.any? {|part| line.include?(part)}
    if !line.include?('  ')
      securities << Block.new(line) 
    else 
      securities.last << line
    end
  end

  securities
    .select(&:monthly?)
    .each do |security|
    security.front_4_mos.each do |line|
      result = [file_nm, security.name] + Line::RANGES.keys.map {|key| line.value(key) }
      output.puts result.join(',')
    end
  end
end
