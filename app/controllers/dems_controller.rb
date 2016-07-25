class DemsController < ApplicationController
  layout 'dem'
  
  def index
    @lon = location_params[:lon]
    @lat = location_params[:lat]
    @real_time_site = Weather::RealTimeStation.new.fetch(@lon, @lat)
    # @statistics = AutoStation::Statistic.new.fetch
    # @statistics.map do |item|
    #   _station = StationInfo.get_by_sitenumber item['sitenumber']
    #   if _station.lon.blank? or _station.lat.blank?
    #     item['distance'] = '-'
    #   else
    #     item['distance'] = _station.calculate_distance(@lon, @lat)
    #   end
    # end
  end

  private
  def location_params
    params.permit(:lon, :lat)
  end
end
