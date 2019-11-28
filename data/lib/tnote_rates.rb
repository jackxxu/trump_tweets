require 'csv'

module CMEGroup
  class TnoteRates
    @rates = Hash[File.read('market/10y_tnote.csv').scan(/(.+?),(.+)/)]

    class << self
      def for(date)
        @rates[date]&.to_f
      end
    end
  end
end