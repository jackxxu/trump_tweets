require 'pry'

Dir["./lib/*.rb"].each {|file| require file }

rates = TnoteRates.new

