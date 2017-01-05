class DemsController < ApplicationController
  layout 'dem'
  
  def index
    @lon = location_params[:lon]
    @lat = location_params[:lat]
    # 所有站的即时信息
    @cimiss = Cimiss.get
    # 当前站即时信息
    @real_time_site = Weather::RealTimeStation.new.fetch(@lon, @lat)
    @real_time_station = Cimiss.getNowStation @cimiss, @real_time_site
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
