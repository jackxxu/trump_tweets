class Option < Block
  attr_reader :type
  def initialize(name, type)
    binding.pry
    @type = type
    super    
  end
end