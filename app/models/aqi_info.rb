# == Schema Information
#
# Table name: aqi_infos
#
#  id         :integer          not null, primary key
#  info       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AqiInfo < ActiveRecord::Base
	# 用户名：8564879f-3d1a-4c4f-9219-47f1fa5a0811
	# 密  码：a1ea259d-068c-4aab-a795-0191f3b50811
	# 访问地址：http://116.228.121.162/sjaqiservice/AQIService.asmx

	# 接口返回数据
	# PM10$55.0μg/m³#0$PM10$53$2$良$2014-08-12 18:00:00#43#Y
	# 数据说明
	# 首要污染物$首要污染物浓度#站点编号$首要污染物$AQI$等级$状态 $时间

	#
	# 注意：当空气质量等级为一级时，没有首要污染物，显示“/”，浓度则显示pm2.5的浓度。对健康的影响及建议措施判断已经参考：
	# http://www.semc.gov.cn/aqi/home/Detail.aspx?id=51b2d3d1-37f1-4927-9733-3960a2384b99
	#  
	#  main_pullotant                 :string(255)
	#  main_pollutant_concentration   :string(255)
	#  siteID                         :integer
	#  aqi_per_1h                     :integer
	#  aqi_per_24h                    :integer
	#  time                           :datetime
	#  level                          :string "良"
	#  grade                          :integer
	#  
	#  1:"PM10" 2:"55.0μg/m³" 3:"0" 4:"PM10" 5:"53"aqi 6:"2"等级 7:"良" 8:"2014-08-12 18:00:00" 9:"43"24小时 10:"Y"

	after_create :save_into_redis

	def self.decode info
		/(.*)\$(.*)\#(.*)\$(.*)\$(.*)\$(.*)\$(.*)\$(.*)\#(.*)\#(.*)/.match(info.force_encoding("UTF-8"))
	end

	def self.real_time 
		_decode = AqiInfo.decode($redis.lrange("aqi_info", 0, 0).first)
		if _decode[8]
			{
		    "datetime" => _decode[8].to_datetime,
		    "aqi" => _decode[5],
		    "level" => _decode[7],
		    "pripoll" => _decode[4] == "/" ? "" : _decode[4],
		    "content" => AqiInfo.content(_decode[7]),
		    "measure" => AqiInfo.measure(_decode[7])
			}
		end
	end

	def self.aqi_weathers
		_list = $redis.lrange "aqi_info", 0, 6
		_list.map do |i|
			_decode =  AqiInfo.decode(i)
			{
		      # "pm2_5_c" => 69.3,
		      # "pm10_c" => 91.6,
		      "time" => _decode[8].to_datetime,
		      # "pm2_5" => 93,
		      # "pm10" => 71,
		      "aqi" => _decode[5],
		      # "aqi_item" => "PM2.5"
			}
		end
	end

	def self.organize_aqi_datas aqi_weathers
    aqi_weathers.map do |aqi_weather|
      [
        aqi_weather['time'].strftime("%Y/%m/%d %H:%M:%S"),
        aqi_weather['aqi'].to_i ||= "-",
        self.aqi_to_color(aqi_weather['aqi'])
      ]
    end
	end

	# def self.time info
	# 	/(.*)\$(.*)\#(.*)\$(.*)\$(.*)\$(.*)\$(.*)\$(.*)\#(.*)\#(.*)/.match(info)[8].to_datetime
	# end

	# aqi影响 对应原接口content
	def self.content level
		{
			"优": "空气质量令人满意，基本无空气污染",
			"良": "空气质量可接受，但某些污染物可能对极少数异常敏感人群健康有较弱影响",
			"轻度污染": "易感人群症状有轻度加剧，健康人群出现刺激症状",
			"中度污染": "进一步加剧易感人群症状，可能对健康人群心脏、呼吸系统有影响",
			"重度污染": "心脏病和肺病患者症状显著加剧，运动耐受力降低，健康人群普遍出现症状",
			"严重污染": "健康人运动耐受力降低，有明显强烈症状，提前出现某些疾病",
		}[level.to_sym]
	end

	def self.measure level
		{
			"优": "各类人群可正常活动",
			"良": "极少数异常敏感人群应减少户外活动",
			"轻度污染": "儿童、老年人及心脏病、呼吸系统疾病患者应减少长时间、高强度的户外锻炼",
			"中度污染": "儿童、老年人及心脏病、呼吸系统疾病患者避免长时间、高强度的户外锻炼，一般人群适量减少户外运动",
			"重度污染": "儿童、老年人和心脏病、肺病患者应停留在室内，停止户外运动，一般人群减少户外运动",
			"严重污染": "儿童、老年人和病人应当停留在室内，避免体力消耗，一般人群应避免户外活动",
		}[level.to_sym]
	end

	def self.aqi_to_color aqi_value
    case aqi_value.to_i
    when (0..50)
      "#23D733"
    when (51..100)
      "#FEEF36"
    when (101..150)
      "#F19626"
    when (151..200)
      "#FC0F1D"
    when (201..300)
      "#9A0B47"
    when (301..1000)
      "#67070A"
    end
  end

	def self.get_info
		uri = URI("http://116.228.121.162/sjaqiservice/AQIService.asmx")
		req = Net::HTTP::Post.new(uri.to_s)
		https = Net::HTTP.new(uri.host,uri.port)
		req.body = "<?xml version=\"1.0\" encoding=\"utf-8\"?>
								<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">
								<soap12:Header>
								  <MySoapHeader xmlns=\"http://tempuri.org/\">
								    <UserName>8564879f-3d1a-4c4f-9219-47f1fa5a0811</UserName>
								    <PassWord>a1ea259d-068c-4aab-a795-0191f3b50811</PassWord>
								  </MySoapHeader>
								  
								</soap12:Header>
								<soap12:Body>
								  <GetRealTimeAirQuality xmlns=\"http://tempuri.org/\">
								    <siteID>0</siteID>
								  </GetRealTimeAirQuality>
								</soap12:Body>
								</soap12:Envelope>"
		
		req["Content-Type"] = "application/soap+xml; charset=utf-8"

		res = https.request(req)
		# puts "Response #{res.code} #{res.message}: #{res.body}
		_info = /<GetRealTimeAirQualityResult>(.*)<\/GetRealTimeAirQualityResult>/.match(res.body) 
		_info = _info ? _info[1] : res.body
		# 转换中文编码
		_info.force_encoding("UTF-8")
		unless _info == 'nodata' || AqiInfo.last.try(:info) == _info
			aqi_info = AqiInfo.create(info: _info)
		end
		p "+++++++++++++++++++"
		p _info

	end

	private
		def save_into_redis
			$redis.lpush "aqi_info", self.info
		end
end
