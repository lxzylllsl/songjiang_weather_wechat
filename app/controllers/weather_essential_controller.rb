class WeatherEssentialController < ApplicationController

  def locate
    
  end

  def index
    @real_time_site = Weather::RealTimeStation.new.fetch(location_params[:lon], location_params[:lat])
    p @real_time_site
    @statistics = AutoStation::Statistic.new.fetch
  end

  private
  def location_params
    params.permit(:lon, :lat)
  end
end
