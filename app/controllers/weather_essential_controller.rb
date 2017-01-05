class WeatherEssentialController < ApplicationController
  respond_to :html, :json
  def locate
    
  end

  def index
    @lon = location_params[:lon]
    @lat = location_params[:lat]
    # 当前站即时信息
    @real_time_site = Weather::RealTimeStation.new.fetch(@lon, @lat)
    # 修正站名
    Cimiss.fix_name(@real_time_site)
    @real_time_station = @real_time_site
    # 气象统计  
    @statistics = AutoStation::Statistic.new.fetch
    # 动态数据
    @dems = Image::DemData.new.fetch
    
    # 替换cimiss 数据
    if @cimiss = Cimiss.get
      # 所有站的即时信息
      Cimiss.fix_name(@statistics)
      Cimiss.fix_name(@cimiss)
      @statistics.map do |item|
        _station = StationInfo.get_by_sitenumber item['sitenumber']
        item['distance'] = (_station.lon.blank? or _station.lat.blank?) ? '-' : _station.calculate_distance(@lon, @lat)
        cache = Cimiss.getNowStation(@cimiss, item["name"])
        item['tempe'] = cache.present? ? cache["tempe"] : '-'
      end
      @real_time_station = Cimiss.getNowStation @cimiss, @real_time_site
      Cimiss.fix_name(@real_time_station)
    end
  end

  private
  def location_params
    params.permit(:lon, :lat)
  end
end
