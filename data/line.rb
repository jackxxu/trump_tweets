class Line
  def initialize(str)
    @str = str
  end

  def time
    str[0, 5].strip
  end

  def open
    str[10, 5]
  end
end