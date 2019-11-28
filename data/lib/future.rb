module CMEGroup
  class Future < Block
    def line_for(month)
      lines.find {|line| line.dt == month}
    end
  end
end