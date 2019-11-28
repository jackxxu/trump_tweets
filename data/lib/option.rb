class Option < Block
  attr_reader :type
  def initialize(name, type)
    @type = type
    super name
  end
end