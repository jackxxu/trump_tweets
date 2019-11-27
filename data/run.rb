require 'pry'
require 'date'

Dir["./lib/*.rb"].each {|file| require file }

rates = TnoteRates.new

Dir.glob("**/*/*.txt")
  .map { |path| DataFile.new(path) }
  .filter { |f| !f.tnote? }
  .map { |f| f.commodity }
  .uniq
  .sort
  .each { |x| puts x }  
  # .map {|f| "#{f.commodity}-#{f.dt.to_s}" }
  # .sort
  # .each {|x| puts x}