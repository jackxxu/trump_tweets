require_relative 'line'

class Block
  attr_reader :security_nm, :lines

  def initialize(security_nm)
    @security_nm = security_nm
    @lines = []
  end

  def << line
    @lines << Line.new(line)
  end

  def monthly?
    !@lines[0].start_with?(/\d/i)
  end

  def front_4_mos
    @lines[0, 4]
  end
end