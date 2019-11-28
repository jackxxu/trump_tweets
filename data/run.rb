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

Dir.glob('market/txt_data_7-31-19/Soybeans_19_7_2019_ags_settlements.txt')
  .map { |path| CMEGroup::DataFile.new(path) }
  .reject { |f| f.tnote? }
  .each { |f| puts "#{f.commodity}-#{f.dt}" }
  .each do |f|
    puts f.options[0].lines[0].volatility
  end