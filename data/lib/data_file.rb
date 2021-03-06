module CMEGroup
  class DataFile
    attr_reader :file_name, :dt, :relevant_future_keys, :path

    DATA_FN_FORMAT = /^([^_]*_)?(\d{1,2})_(\d{1,2})_(\d{4})/
    LINES_TO_SKIP = ['TOTAL', 'END OF REPORT', '---- DAILY ---', 'STRIKE     OPEN']
    MONTHS = %w[JAN FEB MAR APR MAY JUN JLY AUG SEP OCT NOV DEC]
    DATALINE_REG = Regexp.new ('(^' + (MONTHS + ['\d{4}', '\s{4}']).join('|') + ')')
    OPTIONS_REG = /(PUT|CALL)/i

    def initialize(path)
      @path = path
      @file_name = @path.split('/').last
      @fn_parts = @file_name.match(DATA_FN_FORMAT)
      @dt = Date.new(@fn_parts[4].to_i, @fn_parts[3].to_i, @fn_parts[2].to_i)
      @futures, @options = [], []
      @relevant_future_keys =
        (0..6)
          .map {|i| dt >> i}
          .map {|x| "#{MONTHS[x.month-1]}#{x.year.to_s[2,2]}" }
    end

    def commodity
      @fn_parts[1]&.gsub('_', '')&.downcase || 'ags_settlement'
    end

    def options
      current = nil
      File
        .readlines(@path)
        .map    { |line| line.strip }
        .reject { |line| line.empty? }
        .reject { |line| LINES_TO_SKIP.any? { |part| line.include?(part) } }
        .each do |line|
          if line =~ OPTIONS_REG
            # option line
            option = Option.new(self, line)
            future = @futures.find {|f| f.name == option.future_name}
            if option.future_line = future&.line_for(option.month)
              @options << option
              current = @options.last
            else
              # no matching future => no recording
              current = option
            end
          elsif line =~ DATALINE_REG
            # data line
            current << Line.new(line, current) if current
          else
            # future line, as it is the most unpredictable
            @futures << Future.new(self, line)
            current = @futures.last
          end
        end
      @options
    end
  end
end