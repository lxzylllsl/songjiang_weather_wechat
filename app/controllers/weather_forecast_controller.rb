class WeatherForecastController < ApplicationController

  def locate
    
  end

  def index
    # site = LocationUtil.new.reverse(location_params)
    @weather_forecasts = Weather::WeatherForecasts.new.fetch
    @weather_forecasts_size = @weather_forecasts.size
    @real_time_site = Weather::RealTimeStation.new.fetch(location_params[:lon], location_params[:lat])
    @real_time_aqi = Aqi::RealTimeAqi.new.fetch
    @warnings = Warning::CityWarning.new.fetch
  end

  private
  def location_params
    params.permit(:lon, :lat)
  end
end
