require_relative 'line'

class Block
  attr_reader :name, :lines

  def initialize(name)
    @name = name.gsub(',', '')
    @lines = []
  end

  def << line
    @lines << Line.new(line)
  end

  # def monthly?
  #   !@lines[0].value(:time).start_with?(/\d/i)
  # end
end