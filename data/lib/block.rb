require_relative 'line'

module CMEGroup
  class Block
    attr_reader :name, :lines, :file

    def initialize(file, name)
      @file = file
      @name = name.gsub(',', '')
      @lines = []
    end

    def << line
      @lines << line
    end
  end
end
