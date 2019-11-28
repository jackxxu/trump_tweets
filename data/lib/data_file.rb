class DataFile
  attr_reader :file_name, :dt, :relevant_future_keys

  DATA_FN_FORMAT = /^([^_]*_)?(\d{1,2})_(\d{1,2})_(\d{4})/
  LINES_TO_SKIP = ['TOTAL', 'END OF REPORT', '---- DAILY ---', 'STRIKE     OPEN']
  MONTHS = %w[JAN FEB MAR APR MAY JUN JLY AUG SEP OCT NOV DEC]
  DATALINE_REG = Regexp.new ('(^' + (MONTHS + ['\d{4}', '\s{4}']).join('|') + ')')
  FUTURE_NAMES = {
    soybean: 'S Soybean Futures'
  }

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

  def tnote?
    file_name.include?('T-Note')
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
        ln = line.downcase
        if ln.include?('future')
          @futures << Future.new(self, line)
          current = @futures.last
        elsif ln.include?('put') || ln.include?('call')
          option = Option.new(self, line, ln.include?('put') ? :put : :call )
          future = @futures.find {|f| f.name == option.future_name}
          if option.future_line = future.line_for(option.month)
            @options << option
            current = @options.last
          else
            current = nil
          end
        else
          current << Line.new(line, current) if current
        end
      end
    @options
  end
end