require 'penfold'

module CMEGroup
  class Line
    attr_reader :str

    RANGES = {
      time:         0..5,
      price:        0..5,
      open:         6..14,
      high:         16..24,
      low:          26..34,
      last:         36..44,
      settled:      46..54,
      change:       56..62,
      vol:          64..74,
      prev_settled: 76..85,
      prev_vol:     87..97,
      pre_int:      99..109,
    }

    def initialize(str, block)
      @str = str
      @block = block
    end

    def settled
      actual_value(:settled, :prev_settled).to_f
    end

    def open_interest
      value(:pre_int)
    end

    def volume
      actual_value(:vol, :prev_vol)
    end

    def strike
      price = value(:price).to_f.abs
      (0..4)
        .map  { |i| price/(10.0**i) }
        .find { |p| (p/underlying_price).between?(0.3, 3) } || price
    end

    def dt
      value(:time)
    end

    def days_remaining
      month_remaining * 30
    end

    def open_interest
      value(:pre_int).to_f
    end

    def volatility
      risk_free_rate = TnoteRates.for(@block.file.dt.to_s)
      BlackScholes.option_implied_volatility(
        @block.type == :call,
        underlying_price,
        strike,
        @block.tnote_rate/100.0,
        @block.month_remaining*30/365.0,
        settled
      )
    rescue
      0
    end

    private

      def underlying_price
        @block.future_line.settled
      end

      def actual_value(main_field, unch_field)
        val = value(main_field)
        [val, value(:change)].include?('UNCH') ? value(unch_field) : val
      end

      def value(key)
        @str[RANGES[key]]
          &.strip
          &.sub('----', '')
          &.sub('\'', '.') # appro 1/8 w/ decimal point
      end
  end
end