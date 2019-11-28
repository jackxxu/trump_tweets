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
  end
end