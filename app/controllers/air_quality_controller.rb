class AirQualityController < ApplicationController

  def index
  	AqiInfo.get_info
    # @real_time = Aqi::RealTimeAqi.new.fetch
    @forecast_air_quality = Aqi::ForecastAirQuality.new.fetch
    # @aqi_weathers = Aqi::AqiHistory.new.fetch
    # @aqi_datas, @pm25_datas, @pm10_datas, @o3_datas, @no2_datas = Aqi.organize_aqi_datas @aqi_weathers
    @real_time = AqiInfo.real_time
    @aqi_weathers = AqiInfo.aqi_weathers
    @aqi_datas = AqiInfo.organize_aqi_datas @aqi_weathers
  end
end
