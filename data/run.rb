require 'pry'
require 'date'

Dir["./lib/*.rb"].each {|file| require file }

rates = TnoteRates.new

# Dir.glob("**/*/*.txt")
#   .map { |path| DataFile.new(path) }
#   .reject { |f| f.tnote? }
#   .map {|f| "#{f.commodity}-#{f.dt}"}
#   .uniq
#   .sort
#   .each { |x| puts x }  

Dir.glob('market/txt_data_7-31-19/Soybeans_19_7_2019_ags_settlements.txt')
  .map { |path| DataFile.new(path) }
  .reject { |f| f.tnote? }
  .each { |f| puts "#{f.commodity}-#{f.dt}" }
  .each { |f| puts f.blocks.map(&:name)  }