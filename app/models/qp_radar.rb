# 青浦雷达 采集
Radar::RadarImageProcess.class_eval do
    class QpRadarImageProcess < Radar::RadarImageProcess
      def initialize
        super
        @redis_key = 'qp_radar_image_cache'
      end

      def fetch
        super 'qp_radar'
      end
    end
end
# 青浦雷达 RadarSatellis Controller 读取图片
Radar.class_eval do
  class QpRadar < Radar
  	Radar.instance_variables.each do |name|
  		instance_variable_set name, Radar.instance_variable_get(name)
  	end
  	def locate location
  		super location, Radar::RadarImageProcess::QpRadarImageProcess.new.instance_variable_get("@redis_key")
  	end
  end
end