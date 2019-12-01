module CMEGroup
  class Option < Block
    attr_reader :type
    attr_accessor :future_line

    TYPES = [
      { name: 'soy bean', type: :soybeans, future_name: '' }, # ignore SOY BEAN, as it does produce a valid volatility score
      { name: 'week', type: :weekly, future_name: '' }, # ignore weeklys, for volatility score instability
      { name: 'cso', type: :cso, future_name: '' }, # ignore all the CSOs (Calendar Spread)
      { name: 'calendar spread option', type: :cso, future_name: '' }, # ignore all the CSOs (Calendar Spread)
      { name: 'spred', type: :cso, future_name: '' }, # ignore all the CSOs (Calendar Spread)
      { name: 'soy bean oil', type: :soybean_oil, future_name: 'BO Soybean Oil Futures' },
      { name: 'soybean oil', type: :soybean_oil, future_name: 'BO Soybean Oil Futures' },
      { name: 'soybean meal', type: :soybean_meal, future_name: 'SM Soybean Meal Futures' },
      { name: 'soy bean meal', type: :soybean_meal, future_name: 'SM Soybean Meal Futures' },
      { name: 'soybean crush', type: :soybean_crush, future_name: 'BCX SOYBEAN CRUSH' },
      { name: 'soy bean crush', type: :soybean_crush, future_name: 'BCX SOYBEAN CRUSH' },
      { name: 'soybean', type: :soybeans, future_name: 'S Soybean Futures' },
      { name: 'corn', type: :corn, future_name: 'C Corn Futures' },
      { name: 'eu milling wheat', type: :eu_miilling_wheat, future_name: 'WEU EU Milling Wheat Futures' },
      { name: 'hard red spring wheat', type: :hard_red_wheat, future_name: 'MWE Minneapolis Hard Red Spring Wheat Futures' },
      { name: 'kansas city wheat', type: :kansas_wheat, future_name: 'KEF Kansas City Wheat Futures' },
      { name: 'wheat', type: :wheat, future_name: 'W Wheat Futures' },
      { name: 'wh ', type: :wheat, future_name: 'W Wheat Futures' },
      { name: 'cheese', type: :cheese, future_name: 'CSC Cash Settled Cheese Future' },
      { name: 'non-fat dry milk', type: :dry_milk, future_name: 'NF CME NON-FAT DRY MILK FUTURES' },
      { name: 'dry milk', type: :dry_milk, future_name: 'NF CME NON-FAT DRY MILK FUTURES' },
      { name: 'mid-size milk', type: :mid_size_milk, future_name: 'ZX Mid-size Milk Futures' },
      { name: 'class iv milk', type: :milk_iv, future_name: 'DK CME CLASS IV MILK FUTURES' },
      { name: 'non-fat dry milk', type: :nonfat_dry_milk, future_name: 'NF CME NON-FAT DRY MILK FUTURES' },
      { name: 'milk', type: :milk, future_name: 'DA MILK FUTURES' },
      { name: 'feeder cattle', type: :feeder_cattle, future_name: 'FC CME FEEDER CATTLE FUTURES'},
      { name: 'palm oil', type: :palm_oil, future_name: 'FCP BMD Crude Palm Oil Future'},
      { name: 'dry whey', type: :dry_whey, future_name: 'DY DRY WHEY FUTURES'},
      { name: 'kc hrw', type: :kc_wheat, future_name: 'MKC Mini-Sized KC HRW Wheat Futures'},
      { name: 'bmd-kuala lumpar', type: :bmd_kuala_lumpar, future_name: 'KLI BMD-KUALA LUMPAR INDEX FUTURE'},
      { name: 'cme lumber', type: :lumber, future_name: 'LB CME LUMBER FUTURES'},
      { name: 'live cattle', type: :live_cattle, future_name: 'LC CME LIVE CATTLE FUTURES'},
      { name: 'lean hog', type: :lean_hog, future_name: 'LH CME LEAN HOG FUTURES'},
      { name: 'oats', type: :oats, future_name: 'O Oats Futures'},
      { name: 'rough rice', type: :rice, future_name: 'RRF Rough Rice Futures'},
      { name: 'e-mini s&p 500', type: :emini_snp_500, future_name: 'ES   E-MINI S&P 500 FUTURES'},
      { name: 'emini s&p 500', type: :emini_snp_500, future_name: 'ES   E-MINI S&P 500 FUTURES'},
      { name: 'emini s&p options', type: :emini_snp_500, future_name: 'ES   E-MINI S&P 500 FUTURES'},
      { name: '(eom) s&p', type: :emini_snp_500, future_name: 'ES   E-MINI S&P 500 FUTURES'},
      { name: 's&p 500', type: :snp_500, future_name: 'SP   S&P 500 FUTURES'},
      { name: 'emini s&p midcap 400', type: :snp_400, future_name: 'EMD  E-MINI MIDCAP 400 FUTURES'},
      { name: 'e-mini nasdaq-100', type: :nasdaq_100, future_name: 'NQ   E-MINI NASDAQ-100 FUTURES'},
      { name: 'e-mini $5 dow', type: :d5_dow, future_name: 'YM   E-MINI $5 DOW FUTURES'},
      { name: 'e-mini $5 djia', type: :d5_dow, future_name: 'YM   E-MINI $5 DOW FUTURES'},
      { name: 's&p smallcap 600', type: :snp_smallcap_600, future_name: 'SMC  E-MINI S&P SMALL CAP 600 FUTURES'},
      { name: 'apple juice', type: :apple_juice, future_name: 'AJC MGEX APPLE JUICE FUTURE'},
      { name: 'crude oil', type: :sweat_crude_oil, future_name: 'CL Light Sweet Crude Oil Futures'},
      { name: 'butter', type: :butter, future_name: ''}
    ]

    def initialize(file, name)
      @type = name.downcase.include?('put') ? :put : :call
      super file, name
    end

    def future_name
      ln = name.downcase
      TYPES
        .find { |h| ln.include?(h[:name]) }
        .fetch(:future_name)
    rescue
      binding.pry
    end

    def commodity
      ln = name.downcase
      TYPES
        .find { |h| ln.include?(h[:name]) }
        .fetch(:type)
    end

    def month
      @file
        .relevant_future_keys
        .find {|key| name.include?(key)}
    end

    def month_remaining
      file
        .relevant_future_keys
        .find_index {|x| x == month }
    end

    def dt
      @file.dt
    end

    def future_open_interest
      future_line.open_interest
    end

    def line_open_interest
      lines.sum(&:open_interest)
    end

    def volume
      future_line.volume
    end

    def underlying_price
      future_line.settled
    end

    def tnote_rate
      TnoteRates.for(@file.dt.to_s)
    end

    def open_interests
      lines
        .filter {|line| line.open_interest != 0}
    end

    def volatility
      lines
        .sort_by {|x| (x.strike - future_line.settled).abs }
        .fetch(0)
        .volatility
    end
  end
end