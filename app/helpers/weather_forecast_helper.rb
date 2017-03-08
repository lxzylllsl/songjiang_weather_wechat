module WeatherForecastHelper

  def chinese_year
    datas = ChineseLunar::Lunar.new(DateTime.now).lunar_date_in_chinese
    "#{datas[0]}(#{datas[3]})年 #{datas[1]}月#{datas[2]}"
  end

  # 天气图标
  def weather_icon image_name
    _icons = {
			"weather_super_snow.png" => "icon-baoxue",
			"weather_rainstorm.png" => "icon-baoyu",
			"weather_big_rainstorm.png" => "icon-dabaoyu",
			"weather_super_rainstorm.png" => "icon-tedabaoyu",
			"weather_sandstorm.png" => "icon-qiangshachenbao",
			"weather_big_snow.png" => "icon-daxue",
			"weather_big_rain.png" => "icon-dayu",
			"weather_sleet_rain.png" => "icon-dongyu",
			"weather_dust.png" => "icon-fuchen",
			"weather_shower_rain.png" => "icon-zhenyubaitian",
			"weather_thunder_rain.png" => "icon-leizhenyubaitian",
			"weather_sandstorm.png" => "icon-shachenbao",
			"weather_fog.png" => "icon-wu",
			"weather_haze.png" => "icon-mai",
			"weather_little_snow.png" => "icon-xiaoxue",
			"weather_s_m_snow.png" => "icon-xiaodaozhongxue",
			"weather_little_rain.png" => "icon-xiaoyu",
			"weather_jansa.png" => "icon-yangsha",
			"weather_overcast.png" => "icon-yin",
			"weather_sleet.png" => "icon-yujiaxue",
			"weather_mid_snow.png" => "icon-zhongxue",
			"weather_mid_rain.png" => "icon-zhongyu",
			"weather_sunny.png" => "icon-qingbaitian",
			"weather_cloudy.png" => "icon-duoyunqing",
			"weather_hail.png" => "icon-bingbao",
			"weather_big_snow.png" => "icon-zhenxuebaitian"
    }
  	_icons[image_name]
  end

  # 整理天气预报图表数据
  def initChartData weather_data
  	ticks = []
  	low = []
  	low_point = []
  	high = []
  	high_point = []
  	weather_data.each_with_index do |item, index|
  		cache = item['tempe'][0...-1].split('~')
  		ticks << index
      low <<  cache[0].to_i
      high <<  cache[1].to_i
      low_point.push({ value:  cache[0].to_i, xAxis: index, yAxis:  cache[0].to_i - 1.6 })
      high_point.push({ value:  cache[1].to_i, xAxis: index, yAxis:  cache[1].to_i })
  		# low <<  item['temp_low']
  		# high <<  item['temp_high']
  		# low_point.push({ value:  item['temp_low'], xAxis: index, yAxis:  item['temp_low'] - 1.6 })
  		# high_point.push({ value:  item['temp_high'], xAxis: index, yAxis:  item['temp_high'] })
  	end
  	{ticks: ticks, low: low, high: high, low_point: low_point, high_point: high_point}
  end
end
