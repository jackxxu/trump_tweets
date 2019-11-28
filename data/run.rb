require 'pry'
require 'date'

Dir["./lib/*.rb"].each {|file| require file }

# rates = CMEGroup::TnoteRates.new

# Dir.glob("**/*/*.txt")
#   .map { |path| DataFile.new(path) }
#   .reject { |f| f.tnote? }
#   .map {|f| "#{f.commodity}-#{f.dt}"}
#   .uniq
#   .sort
#   .each { |x| puts x }

OPTION_ATTRS = %i{dt commodity type name month_remaining volatility volume strike line_open_interest future_open_interest tnote_rate}

File.open('output.csv', 'w') do |output|
  output.puts OPTION_ATTRS.join(',')
  Dir.glob('market/**/Soybeans_*.txt')
    .map { |path| CMEGroup::DataFile.new(path) }
    .reject { |f| f.tnote? }
    .each { |f| puts "#{f.commodity}-#{f.dt}" }
    .flat_map(&:options)
    .each do |option|
      output.puts OPTION_ATTRS.map {|key| option.send(key)}.join(',')
    end
end