module CMEGroup
  class Option < Block
    attr_reader :type
    attr_accessor :future_line

    TYPES = [
      { name: 'soybean oil', type: :soybean_oil },
      { name: 'soybean crush', type: :soybean_crush },
      { name: 'soybean meal', type: :soybean_meal },
      { name: 'soybean', type: :soybeans, future_name: 'S Soybean Futures' },
    ]

    def initialize(file, name, type)
      @type = type
      super file, name
    end

    def future_name
      ln = name.downcase
      TYPES
        .find { |h| ln.include?(h[:name]) }
        .fetch(:future_name)
    end

    def commodity
      ln = name.downcase
      TYPES
        .find { |h| ln.include?(h[:name]) }
        .fetch(:name)
    end

    def month
      @file
        .relevant_future_keys
        .find {|key| name.include?(key)}
    end

    def month_remaining
      file
        .relevant_future_keys
        .find_index {|x| x == month }
    end

    def dt
      @file.dt
    end

    def future_open_interest
      future_line.open_interest
    end

    def line_open_interest
      lines.sum(&:open_interest)
    end

    def volume
      future_line.volume
    end

    def strike
      future_line.strike
    end

    def tnote_rate
      TnoteRates.for(@file.dt.to_s)
    end

    def open_interests
      lines
        .filter {|line| line.open_interest != 0}
    end

    def volatility
      lines
        .sort_by {|x| (x.strike - future_line.settled).abs }
        .fetch(0)
        .volatility
    end
  end
end