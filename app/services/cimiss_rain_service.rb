class A
	
	def initialize
		@time_oclock = Time.zone.now.strftime("%Y%m%d%H0000")
		@time_now = Time.zone.now.strftime("%Y%m%d%H%M%S")
	end

  def get_per_hour_rain
    time1 = Time.now.zone
  end

  def get_rain_sum_this_hour
    sum_rain_uri = URI.parse("http://t.weather-huayun.com:8080/cimiss-web/api?userId=BCSH_SHSJ_api&pwd=67739161&interfaceId=statSurfEleInRegion&dataCode=SURF_CHN_PRE_MIN&elements=Station_Name&statEles=Sum_PRE&timeRange=[#{time1},#{time2}]&adminCodes=310117&dataFormat=json")
  end
  def get_oclock_sum_rain_list
  	time2 = Time.zone.now.strftime("%Y%m%d%H0000") #@time_oclock 
  	# [ 1, 3, 6, 24 ].each do |n|
  		time1 = ( Time.zone.now - .hours ).strftime("%Y%m%d%H0000")
  		oclock_sum_rain = URI.parse("http://t.weather-huayun.com:8080/cimiss-web/api?userId=BCSH_SHSJ_api&pwd=67739161&interfaceId=statSurfPreInRegion&elements=Station_Name,Station_Id_C&timeRange=[#{time1},#{time2}]&adminCodes=310117&limitCnt=30&dataFormat=html")
  		sum_rain_body = Net::HTTP.get(sum_rain_uri)
			sum_data = JSON.parse(sum_rain_body.force_encoding('utf-8'))


  end
  	
time.oclock_string
'oclock_rain_list'    '2017031301'



'sum_this_hour_rain'

'last_3_hours_rain'
	$redis.lrange 'oclock_rain_list' 0 1 + $redis.get 'sum_this_hour_rain'
'last_6_hours_rain'
	$redis.lrange 0 4 + 
'last_24_hours_rain'

[0, 3, 6, 24]


( $redis.llen 'oclock_rain_list' - 24 ).times do |n|
	break if n <= 0
	(time.now -  n.hours )


$redis.lpush

$redis.lrange



def check_oclock_rain_list
	
end






def get_ds uri, options={}
	options.each do |key, val| 
		uri.gsub("\#{#{key}}", val)
	end
	body = Net::HTTP.get(URI.parse(uri))
	data = JSON.parse(body.force_encoding('utf-8'))
	# p ' --- finish http ---'
	p  data['DS']
end







end
# strftime("%Y-%m-%d %H")}:00
# strftime('%Y-%m-%d %H:%M')
# '20170313000000'.to_time.strftime('%Y-%m-%d %H:%M')
# '20170313010000'.to_time.strftime('%Y-%m-%d %H:%M')
# AutoStation.where(sitenumber: '98210').where("datetime in (#{'20170313000000'.to_time.strftime('%Y-%m-%d %H:%M')}, #{'20170313010000'.to_time.strftime('%Y-%m-%d %H:%M')})")

