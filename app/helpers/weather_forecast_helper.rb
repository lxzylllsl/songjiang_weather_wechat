module WeatherForecastHelper

  def chinese_year
    datas = ChineseLunar::Lunar.new(DateTime.now).lunar_date_in_chinese
    "#{datas[0]}(#{datas[3]})年 #{datas[1]}月#{datas[2]}"
  end
end
