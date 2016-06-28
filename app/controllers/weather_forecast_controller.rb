class WeatherForecastController < ApplicationController

  def locate
    
  end

  def index
    p location_params
    LocationUtil.new.reverse(location_params)
  end

  private
  def location_params
    params.permit(:lon, :lat)
  end
end
