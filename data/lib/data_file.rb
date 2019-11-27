class DataFile
  attr_reader :file_name

  DATA_FN_FORMAT = /^([^_]*_)?(\d{1,2})_(\d{1,2})_(\d{4})/
  LINES_TO_SKIP = ['TOTAL', 'END OF REPORT', '---- DAILY ---', 'STRIKE     OPEN']
  MONTHS = %w[JAN FEB MAR APR MAY JUN JLY AUG SEP OCT NOV DEC] 
  DATALINE_REG = Regexp.new ('(^' + (MONTHS + ['\d{4}', '\s{4}']).join('|') + ')')

  def initialize(path) 
    @path = path
    @file_name = @path.split('/').last
    @fn_parts = @file_name.match(DATA_FN_FORMAT)
  end

  def tnote?
    file_name.include?('T-Note')
  end

  def commodity
    @fn_parts[1]&.gsub('_', '')&.downcase || 'ags_settlement'
  end

  def dt
    Date.new(@fn_parts[4].to_i, @fn_parts[3].to_i, @fn_parts[2].to_i)
  end

  def blocks
    File
      .readlines(@path)
      .map    { |line| line.strip }
      .reject { |line| line.empty? }
      .reject { |line| LINES_TO_SKIP.any? { |part| line.include?(part) } }
      .reject { |line| line =~ DATALINE_REG }
  end
end