class WeatherForecastController < ApplicationController

  def locate
    
  end

  def index
    # site = LocationUtil.new.reverse(location_params)
    @weather_forecasts = Weather::WeatherForecasts.new.fetch
    @weather_forecasts_size = @weather_forecasts.size
    # 所有站的即时信息
    @cimiss = Cimiss.get
    # 当前站即时信息
    @real_time_site = Weather::RealTimeStation.new.fetch(location_params[:lon], location_params[:lat])
    @real_time_station = @cimiss ? (Cimiss.getNowStation @cimiss, @real_time_site) : @real_time_site

    @real_time_aqi = Aqi::RealTimeAqi.new.fetch
    @warnings = Warning::SongjiangWarning.new.fetch

    @poem = Poem.pick

  end

  private
  def location_params
    params.permit(:lon, :lat)
  end
end
