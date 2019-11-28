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

Dir.glob('market/txt_data_7-31-19/Soybeans_19_7_2019_ags_settlements.txt')
  .map { |path| CMEGroup::DataFile.new(path) }
  .reject { |f| f.tnote? }
  .each { |f| puts "#{f.commodity}-#{f.dt}" }
  .flat_map(&:options)
  .each do |option|
    puts OPTION_ATTRS.map {|key| option.send(key)}.join(',')
  end