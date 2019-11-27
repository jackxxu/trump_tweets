require 'pry'
require 'date'

Dir["./lib/*.rb"].each {|file| require file }

rates = TnoteRates.new

Dir.glob("**/*/*.txt")
  .map { |path| DataFile.new(path) }
  .filter { |f| !f.tnote? }
  .each {|f| puts f.blocks }
  # .map { |f| f.blocks }
  # .uniq
  # .sort
  # .each { |x| puts x }  
