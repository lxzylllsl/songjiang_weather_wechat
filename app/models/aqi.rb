class Aqi
  attr_accessor :time, :aqi, :o3, :pm10, :pm2_5, :no2, :aqi_item, :pm10_c, :pm2_5_c, :o3_c, :no2_c

  class RealTimeAqi
    include NetworkMiddleware

    def initialize
      @root = self.class.name.to_s
      super
    end

    def fetch
      _result = get_data({method: 'get', data: {
        appid: @appid,
        appkey: @appkey
      }}, {})
      _result.fetch('data', {})
    end  
  end

  class ForecastAirQuality
    include NetworkMiddleware

    def initialize
      @root = self.class.name.to_s
      super
    end

    def fetch
      params_hash = {
        method: 'get',
        data: {appid: @appid, appkey: @appkey}
      }
      result = get_data(params_hash, {})
      p result
      result['data']['list']
    end
  end

  class AqiHistory
    include NetworkMiddleware
    
    def initialize
      @root = self.class.name.to_s
      super
      @api_path = URI::escape("#{@api_path}上海")
    end

    def fetch
      params_hash = {
        method: 'get'
      }

      result = get_data(params_hash, {})
      list = []
      result.each do |item|
        aqi_weather = Aqi.new
        aqi_weather.o3_c = item.try(:[], "o3")
        aqi_weather.pm2_5_c = item.try(:[], "pm2_5")
        aqi_weather.pm10_c = item.try(:[], "pm10")
        aqi_weather.no2_c = item.try(:[], "no2")
        aqi_weather.time = DateTime.parse item["time"]
        aqi_weather.fill_aqi_item
        list << aqi_weather
      end
      list
    end

  end

  # 整理获取AQI图表需要的相应数据
  def self.organize_aqi_datas aqi_weathers
    aqi_datas = aqi_weathers.map do |aqi_weather|
      [
        aqi_weather.time.strftime("%Y/%m/%d %H:%M:%S"),
        aqi_weather.aqi ||= "-",
        self.aqi_to_color(aqi_weather.aqi)
      ]
    end
    pm25_datas = aqi_weathers.map do |aqi_weather|
      [
        aqi_weather.time.strftime("%Y/%m/%d %H:%M:%S"),
        aqi_weather.pm2_5 ||= "-",
        self.aqi_to_color(aqi_weather.pm2_5)
      ]
    end
    pm10_datas = aqi_weathers.map do |aqi_weather|
      [
        aqi_weather.time.strftime("%Y/%m/%d %H:%M:%S"),
        aqi_weather.pm10 ||= "-",
        self.aqi_to_color(aqi_weather.pm10)
      ]
    end
    o3_datas = aqi_weathers.map do |aqi_weather|
      [
        aqi_weather.time.strftime("%Y/%m/%d %H:%M:%S"),
        aqi_weather.o3 ||= "-",
        self.aqi_to_color(aqi_weather.o3)
      ]
    end
    no2_datas = aqi_weathers.map do |aqi_weather|
      [
        aqi_weather.time.strftime("%Y/%m/%d %H:%M:%S"),
        aqi_weather.no2 ||= "-",
        self.aqi_to_color(aqi_weather.no2)
      ]
    end
    [aqi_datas, pm25_datas, pm10_datas, o3_datas, no2_datas]
  end
  
  def self.aqi_to_color aqi_value
    case aqi_value.to_i
    when (0..50)
      "#23D733"
    when (51..100)
      "#FEEF36"
    when (101..150)
      "#F19626"
    when (151..200)
      "#FC0F1D"
    when (201..300)
      "#9A0B47"
    when (301..1000)
      "#67070A"
    end
  end

  def fill_aqi_item
      self.pm2_5 = Aqi.cal_aqi pm2_5_c, :pm2_5
      self.pm10  = Aqi.cal_aqi pm10_c, :pm10
      self.o3    = Aqi.cal_aqi o3_c, :o3
      self.no2   = Aqi.cal_aqi no2_c, :no2
      self.aqi   = [o3.to_i, pm10.to_i, pm2_5.to_i, no2.to_i].max
      if aqi == pm2_5
        self.aqi_item = "PM2.5"
      elsif aqi == pm10
        self.aqi_item = "PM10"
      elsif aqi == o3
        self.aqi_item = "O3"
      elsif aqi == no2
        self.aqi_item = "NO2"
      end 
    end

    private
    def self.cal_aqi raw_value, type
      aqi_map = {
        pm10: {
          (0..50) => (0..50),
          (50..150) => (50..100),
          (150..250) => (100..150),
          (250..350) => (150..200),
          (350..420) => (200..300),
          (420..500) => (300..400),
          (500..600) => (400..500),
          (600..6000) => (500..600)
        },
        pm2_5: {
          (0..35) => (0..50),
          (35..75) => (50..100),
          (75..115) => (100..150),
          (115..150) => (150..200),
          (150..250) => (200..300),
          (250..350) => (300..400),
          (350..500) => (400..500),
          (500..6000) => (500..600)
        },
        o3: {
          (0..160) => (0..50),
          (160..200) => (50..100),
          (200..300) => (100..150),
          (300..400) => (150..200),
          (400..800) => (200..300),
          (800..1000) => (300..400),
          (1000..1200) => (400..500),
          (1200..6000) => (500..600)
        },
        no2: {
          (0..100) => (0..50),
          (100..200) => (50..100),
          (200..700) => (100..150),
          (700..1200) => (150..200),
          (1200..2340) => (200..300),
          (2340..3090) => (300..400),
          (3090..3840) => (400..500),
          (3840..6000) => (500..600)
        }
      }
      convert_map = aqi_map[type]
      convert_map.each do |k, v|
        if k.include? raw_value
          c_low = k.begin
          c_high = k.end
          i_low = v.begin
          i_high = v.end
          api_value = (i_high - i_low).to_f * (raw_value - c_low) / (c_high - c_low) + i_low
          api_value = api_value > 500 ? 500 : api_value
          return api_value.round(0)
        end
      end
      return nil
    end  
end
