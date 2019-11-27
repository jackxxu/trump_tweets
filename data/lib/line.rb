class Line
  RANGES = {
    time:         0..5,
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

  def initialize(str)
    @str = str
  end

  def value(key)
    @str[RANGES[key]]
      &.strip
      &.sub('----', '')
      &.sub('UNCH', '0')
      &.sub('\'', '.')
  end
end