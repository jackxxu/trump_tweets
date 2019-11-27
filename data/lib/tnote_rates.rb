require 'csv'

class TnoteRates
  attr_reader :rates
  def initialize
    @rates = Hash[File.read('market/10y_tnote.csv').scan(/(.+?),(.+)/)]
  end

  def for(date)
    @rates[date]
  end
end