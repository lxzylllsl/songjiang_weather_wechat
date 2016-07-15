# == Schema Information
#
# Table name: station_infos
#
#  id         :integer          not null, primary key
#  sitenumber :string(255)
#  name       :string(255)
#  area       :string(255)
#  sitetype   :string(255)
#  address    :string(255)
#  lon        :float(24)
#  lat        :float(24)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class StationInfo < ActiveRecord::Base
  
  after_commit :save_to_cache

  def as_json(options=nil)
    {
      sitenumber: sitenumber,
      name: name,
      area: area,
      lon: lon,
      lat: lat
    }
  end

  def self.get_by_sitenumber sitenumber
    p sitenumber
    station_json = $redis.hget("station_infos_cache", sitenumber)
    p station_json
    item = MultiJson.load(station_json)
    StationInfo.new(item)
  end

  def calculate_distance lon, lat
    _lon = lon.to_f
    _lat = lat.to_f
    distance = LocationUtil.get_distance(self.lon, self.lat, _lon, _lat)
    distance.round(0)
  end

  def save_to_cache
    $redis.hset "station_infos_cache", sitenumber, self.to_json
  end
end
