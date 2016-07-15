class WeatherEssentialController < ApplicationController

  def locate
    
  end

  def index
    @real_time_site = Weather::RealTimeStation.new.fetch(location_params[:lon], location_params[:lat])
    @statistics = AutoStation::Statistic.new.fetch
    @statistics.map do |item|
      _station = StationInfo.get_by_sitenumber item['sitenumber']
      item['distance'] = _station.calculate_distance(location_params[:lon], location_params[:lat])
    end
  end

  private
  def location_params
    params.permit(:lon, :lat)
  end
end
