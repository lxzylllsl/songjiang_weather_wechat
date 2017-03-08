class Weather
  
  class RealTimeStation
    include NetworkMiddleware  

    def initialize
      @root = self.class.name.to_s
      super
    end

    def fetch lon, lat
      _result = get_data({method: 'get', data: {
        appid: @appid,
        appkey: @appkey,
        lon: lon,
        lat: lat
      }}, {})
      _result.fetch('data', {})
    end
  end
  
  class WeatherForecasts
    include NetworkMiddleware
    include Syncopate

    def initialize
      @root = self.class.name.to_s
      
      super
    end

    def fetch
      _result = get_data({method: 'get', data: {
        appid: @appid,
        appkey: @appkey,
        city_name: '上海'
      }}, {})
      items = _result.fetch('data', {}).fetch('items', [])
      items.map do |item|
        # _datetime = item['report_date'].to_datetime
        # item['report_date'] = _datetime.strftime('%m.%d')
        _datetime = item['datatime'].to_datetime
        item['datatime'] = _datetime.strftime('%m.%d')
        item['week'] = _datetime.strftime('%a')
        weathers = Weather.filter(analyzed(item['weather']))
        if weathers[0].eql?(weathers[-1])
          item['weather'] = weathers[0]
        else
          item['weather'] = weathers.join('转')
        end
        item['first_icon'] = Weather.get_pic_file weathers[0]
        item['second_icon'] = Weather.get_pic_file weathers[-1]
      end

      items
    end
  end

  def self.filter(items)
    results = []
    items.each do |item|
      _val = get_pic_text(item)
      results << _val if _val.present?
    end
    [results[0], results[-1]]
  end

  def self.get_pic_text text
    weather_list = ["暴雪", "暴雨", "大暴雨", "特大暴雨", "强沙尘暴", "大雪", "大雨",
      "冻雨", "浮尘", "阵雨", "雷阵雨", "沙尘暴", "雾", "小雪", "小雨", "扬沙", "阴",
      "雨夹雪", "中雪", "中雨", "晴", "多云", "冰雹", "阵雪", "浓雾", "强浓雾", "霾",
      "中度霾", "重度霾", "严重霾", "大雾", "特强浓雾"]
    text if weather_list.include?(text)
  end

  def self.get_pic_file text
    bg_image_list = {
      "暴雪" => "weather_super_snow.png",
      "暴雨" => "weather_rainstorm.png",
      "大暴雨" => "weather_big_rainstorm.png",
      "特大暴雨" => "weather_super_rainstorm.png",
      "强沙尘暴" => "weather_sandstorm.png",
      "大雪" => "weather_big_snow.png",
      "大雨" => "weather_big_rain.png",
      "冻雨" => "weather_sleet_rain.png",
      "浮尘" => "weather_dust.png",
      "阵雨" => "weather_shower_rain.png",
      "雷阵雨" => "weather_thunder_rain.png",
      "沙尘暴" => "weather_sandstorm.png",
      "雾" => "weather_fog.png",
      "霾" => "weather_haze.png",
      "小雪" => "weather_little_snow.png",
      "小到中雪" => "weather_s_m_snow.png",
      "小雨" => "weather_little_rain.png",
      "扬沙" => "weather_jansa.png",
      "阴" => "weather_overcast.png",
      "雨夹雪" => "weather_sleet.png",
      "中雪" => "weather_mid_snow.png",
      "中雨" => "weather_mid_rain.png",
      "晴" => "weather_sunny.png",
      "多云" => "weather_cloudy.png",
      "冰雹" => "weather_hail.png",
      "阵雪" => "weather_big_snow.png"
    }
    return bg_image_list[text]
  end
end
