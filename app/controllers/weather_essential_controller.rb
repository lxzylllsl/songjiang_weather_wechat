class WeatherEssentialController < ApplicationController

  def locate
    
  end

  def index
    @lon = location_params[:lon]
    @lat = location_params[:lat]
    # 所有站的即时信息
    @cimiss = Cimiss.get
    # 当前站即时信息
    @real_time_site = Weather::RealTimeStation.new.fetch(@lon, @lat)
    @real_time_station = Cimiss.getNowStation @cimiss, @real_time_site["name"]
    # 气象统计
    @statistics = AutoStation::Statistic.new.fetch
    @statistics.map do |item|
      _station = StationInfo.get_by_sitenumber item['sitenumber']
      item['distance'] = (_station.lon.blank? or _station.lat.blank?) ? '-' : _station.calculate_distance(@lon, @lat)
      cache = Cimiss.getNowStation(@cimiss, item["name"])
      item['tempe'] = cache.present? ? cache["tempe"] : '-'
    end
    # 动态数据
    @dems = Image::DemData.new.fetch
  end

  private
  def location_params
    params.permit(:lon, :lat)
  end
end
