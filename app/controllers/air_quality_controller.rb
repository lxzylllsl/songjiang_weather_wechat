class AirQualityController < ApplicationController

  def index
    @real_time = Aqi::RealTimeAqi.new.fetch
    @forecast_air_quality = Aqi::ForecastAirQuality.new.fetch
    @aqi_weathers = Aqi::AqiHistory.new.fetch
    @aqi_datas, @pm25_datas, @pm10_datas, @o3_datas, @no2_datas = Aqi.organize_aqi_datas @aqi_weathers
  end
end
