module CMEGroup
  class Option < Block
    attr_reader :type
    attr_accessor :future_line

    TYPES = [
      { name: 'soybean oil', type: :soybean_oil, future_name: 'BO Soybean Oil Futures' },
      { name: 'soybean meal', type: :soybean_meal, future_name: 'SM Soybean Meal Futures' },
      { name: 'soybeans option', type: :soybeans, future_name: 'S Soybean Futures' },
      { name: 'soybean option', type: :soybeans, future_name: 'S Soybean Futures' },
      { name: 'soybean crush', type: :soybean_crush, future_name: 'BCX SOYBEAN CRUSH' },
      { name: 'corn option', type: :corn, future_name: 'C Corn Futures' },
      { name: 'wheat option', type: :wheat, future_name: 'W Wheat Futures' },
    ]

    def initialize(file, name)
      @type = name.downcase.include?('put') ? :put : :call
      super file, name
    end

    def future_name
      ln = name.downcase
      TYPES
        .find { |h| ln.include?(h[:name]) }
        .fetch(:future_name)
    rescue
      binding.pry
    end

    def commodity
      ln = name.downcase
      TYPES
        .find { |h| ln.include?(h[:name]) }
        .fetch(:type)
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

    def underlying_price
      future_line.settled
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