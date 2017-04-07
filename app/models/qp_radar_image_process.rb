# 青浦雷达
class Radar::RadarImageProcess::QpRadarImageProcess < Radar::RadarImageProcess
  
  def initialize
    @redis_key = "qp_radar_image_cache"
    super
  end

  def fetch
    super 'qp_radar'
  end
end