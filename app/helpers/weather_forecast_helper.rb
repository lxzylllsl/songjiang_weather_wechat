module WeatherForecastHelper

  def chinese_year(year=Date.today.year)
    "#{ChineseYear.cyclical(year)}(#{ChineseYear.shengxiao_year(year)})年"
  end
end
