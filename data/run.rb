require 'pry'
require 'date'

Dir["./lib/*.rb"].each {|file| require file }

DATA_FN_FORMAT = /^([^_]*_)?(\d{1,2})_(\d{1,2})_(\d{4})/

rates = TnoteRates.new

Dir.glob("**/*/*.txt")
  .select {|f| !f.split('/').last.include?('T-Note') }
  .map do |f|
    file_nm = f.split('/').last  
    m = file_nm.match(DATA_FN_FORMAT)
    commodity = (m[1] || 'ags_settlement').gsub('_', '').downcase
    dt = Date.new(m[4].to_i, m[3].to_i, m[2].to_i)
    "#{commodity}-#{dt.to_s}"
  end
  .sort
  .each {|x| puts x}