require 'pry'
require 'date'

Dir["./lib/*.rb"].each {|file| require file }

rates = TnoteRates.new

Dir.glob("**/*/*.txt")
  .map { |path| DataFile.new(path) }
  .reject { |f| f.tnote? }
  .map {|f| "#{f.commodity}-#{f.dt}"}
  .uniq
  .sort
  .each { |x| puts x }  
