class DataFile
  attr_reader :file_name

  DATA_FN_FORMAT = /^([^_]*_)?(\d{1,2})_(\d{1,2})_(\d{4})/

  def initialize(path) 
    @path = path
    @file_name = @path.split('/').last
    @fn_parts = @file_name.match(DATA_FN_FORMAT)
  end

  def tnote?
    file_name.include?('T-Note')
  end

  def commodity
    @fn_parts[1]&.gsub('_', '')&.downcase
  end

  def dt
    Date.new(@fn_parts[4].to_i, @fn_parts[3].to_i, @fn_parts[2].to_i)
  end
end