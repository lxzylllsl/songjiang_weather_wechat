# 青浦雷达 采集
class Radar::RadarImageProcess::QpRadarImageProcess < Radar::RadarImageProcess
  def initialize
    super
     @redis_key = "qp_radar_image_cache"
  end

  def fetch
    super 'qp_radar'
  end
end

# 青浦雷达 RadarSatellis Controller 读取图片
class Radar::QpRadar < Radar
	Radar.instance_variables.each do |name|
		instance_variable_set name, Radar.instance_variable_get(name)
	end
	def self.locate location
		super location, Radar::RadarImageProcess::QpRadarImageProcess.new.instance_variable_get("@redis_key")
	end
end