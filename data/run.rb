require 'pry'
require 'date'

Dir["./lib/*.rb"].each {|file| require file }

rates = TnoteRates.new

Dir.glob("**/*/*.txt")
  .map {|path| DataFile.new(path) }
  .filter {|f| !f.tnote? }
  .map {|f| "#{f.commodity || 'ags_settlement'}-#{f.dt.to_s}" }
  .sort
  .each {|x| puts x}