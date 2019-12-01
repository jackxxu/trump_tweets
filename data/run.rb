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

OPTION_ATTRS = %i{dt commodity type name file_name month_remaining volatility volume underlying_price line_open_interest future_open_interest tnote_rate}
IGNORE_FN_PATTERNS = ['T-Note', '_int_settlements', 'Crude Oil', 'nymex_settlements']

File.open('options.csv', 'w') do |output|
  output.puts OPTION_ATTRS.join(',')
  Dir.glob('market/**/*.txt')
    .map { |path| CMEGroup::DataFile.new(path) }
    .reject { |f| IGNORE_FN_PATTERNS.any? {|x| f.file_name.include?(x)} }
    .each { |f| puts "#{f.commodity}-#{f.dt}" }
    .flat_map(&:options)
    .sort_by { |o| "#{o.dt}-#{o.commodity}-#{o.type}-#{o.month}" }
    .each do |option|
      output.puts OPTION_ATTRS.map {|key| option.send(key)}.join(',')
    end
end