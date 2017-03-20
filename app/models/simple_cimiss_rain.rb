class SimpleCimissRain

	
	# # 松江气象文档说明 #
	# 	过去3小时雨量累计值
	# 	（如当前时间为9:25，3小时雨量为7、8、9时3个正点雨量的累计值）
	#  	24小时累计雨量：过去24小时雨量累计值
	# 	（如当前时间为2日9:25，24小时雨量为1日10时~2日9时24个正点雨量的累计值）。
	# ....
	# 并不是 .. 3 hours rain = last 2 hours + this hour 

	include HttpHelper
	include RedisHelper
	# 标准格式 ：
	# { 
	# 	"农业中心"=>{
	# 		"SUM_PRE_1H"=>"0", "COUNT_PRE_1H"=>"3.00", "SUM_PRE"=>"0"
	# 		}, 
	# 	"西部渔村"=>{
	# 		"SUM_PRE_1H"=>"0", "COUNT_PRE_1H"=>"3.00", "SUM_PRE"=>"0"
	# 		}
	#  }

	def initialize 
		@now = Time.zone.now
		# url 除站名等外，气象要素字段与统计函数参数 限定统一大写
		# # 小时累计
		# sum_hour_rain_url = 'http://t.weather-huayun.com:8080/cimiss-web/api?userId=BCSH_SHSJ_api&pwd=67739161&interfaceId=statSurfPreInRegion&elements=Station_Name,Q_PRE_1h&timeRange=[#{time1},#{time2}]&adminCodes=310117&limitCnt=30&dataFormat=json'
		# # 分钟累计
		# sum_min_rain_url = 'http://t.weather-huayun.com:8080/cimiss-web/api?userId=BCSH_SHSJ_api&pwd=67739161&interfaceId=statSurfEleInRegion&dataCode=SURF_CHN_PRE_MIN&elements=Station_Name&statEles=SUM_PRE&timeRange=[#{time1},#{time2}]&adminCodes=310117&dataFormat=json'
		# station_name_list = ["农业中心", "西部渔村", "佘山", "松江", "九亭", "车墩", "天马山", "泗泾", "泖港", "五厍", "桐泾", "叶榭", "浦南花卉", "石湖荡", "新桥", "新浜", "第一中学", "泰晤士小镇", "永丰街道", "松江工业区"]
	end
	

	def sum_multi_mins_rain
		sum_min_rain_url = 'http://t.weather-huayun.com:8080/cimiss-web/api?userId=BCSH_SHSJ_api&pwd=67739161&interfaceId=statSurfEleInRegion&dataCode=SURF_CHN_PRE_MIN&elements=Station_Name,Q_PRE&statEles=SUM_PRE&timeRange=[#{time1},#{time2}]&adminCodes=310117&orderBy=Q_PRE_1H:desc&dataFormat=json'
		# 'http://10.228.89.55/cimiss-web/api?userId=BCSH_SHSJ_api&pwd=67739161&interfaceId=statSurfPreInRegion&elements=Station_Name,Q_PRE_1H&timeRange=[20170319000000,20170320000000]&adminCodes=310117&orderBy=Q_PRE_1H:asc&dataFormat=json'
		time1 = @now.oclock
		time2 = @now
		body = cimiss_get(sum_min_rain_url, { time1: time1, time2: time2 })
		if body # 访问成功
p body
			data = last_data_parse(body)
			$redis.set_cimiss_hash 'one_hour_rain', data, @now
			data
		end	
	end

	# three_hour_rain, six_hour_rain
	def sum_last_multi_hours_rain num
		# xx - 20170313 09:30 取得的是09:00 数据 代表 8:00 - 9:00 累计雨量
		sum_hour_rain_url = 'http://t.weather-huayun.com:8080/cimiss-web/api?userId=BCSH_SHSJ_api&pwd=67739161&interfaceId=statSurfPreInRegion&elements=Station_Name,Q_PRE_1H&timeRange=[#{time1},#{time2}]&adminCodes=310117&limitCnt=30&dataFormat=json'
		time1 = @now - num.hours 
		time2 = @now
		
		body = cimiss_get(sum_hour_rain_url, { time1: time1, time2: time2 })
		if body # 访问成功
p body
			data = last_data_parse(body)
			$redis.set_cimiss_hash "last_#{num}_hours_sum_rain", data, @now
			data
		end	
	end

	# 得到站名集合
	def get_station_name
		# $redis station_name_list
	end

	# 关于 质控码
	# 思路1 redis 储存质控码 替换时判断 方便查询质控状态 不过？是分钟/小时更新没必要有记录
	# 思路2 存入redis时 判断， check_corr_id
	def check_corr_id item
		output = item.clone
		item.each do |key, val|
			# sum or other 统计函数
			corr_id = "Q_#{key.gsub('SUM_' , '')}"
																		# nil.to_i -> 0 'aa'.to_i-> 0 
			output.except!(key) unless item[corr_id].to_i.in?([0, 3, 4]) 
			output.except!(corr_id)
		end
		output
	end

	# column_redis_info { column: redis_key }
	ColumnInRedisInfo = {
			one_hour_rain: {
				column: 'SUM_PRE',
				redis_key: 'one_hour_rain'
			}


		}
		
		
	
	# 合并 采集数据的多组数据  ...可用deep_merge代替？
	def self.join_mutli_cimiss_data redis_keys
		# 会出现重名
		# redis_info.keys.map{ |key| $redis.hgetall(key).to_a }.reduce(:+).group_by{|x|x[0]}.map {|station_name, info| [station_name, info.flatten.uniq[1..-1].reduce(:merge)]}.to_h
		redis_keys.map{ |key| 
				$redis.hgetall(key).to_a 
			}.reduce(:+).group_by{ |ary_from_hash| 
					ary_from_hash[0] # 根据站名分类 
				}.map { |station_name, info| 
						[ 
							station_name, 
							info.flatten.uniq[1..-1].reduce(:merge)
						]
					}.to_h

	end
		options = {
			one_hour_rain: { 'SUM_PRE' => 'one_hour_rain'},
			last_3_hours_sum_rain: { 'SUM_PRE_1H' => 'three_hour_rain'},
			last_6_hours_sum_rain: { 'SUM_PRE_1H' => 'six_hour_rain'},
			last_24_hours_sum_rain: { 'SUM_PRE_1H' => 'one_day1_rain'},
		}
	# 1. 在join时rename ✔️
	# 2. 采集时 rename -> join时仍可能需要rename
	# **
	def self.join_and_rename options
		# options.map { |redis_key, rename_options| $redis.get_cimiss_hash(redis_key).to_a.map { |station_name, data| [ station_name, data.map{|old_key, new_key| [new_key, data[old_key]]}.to_h]}.to_h }.reduce(:deep_merge)
		options.map { |redis_key, rename_options| 
			$redis.get_cimiss_hash(redis_key).to_a.map { |station_name, data| 
				[ 
					station_name, 
					rename_options.map { |new_key, old_key| 
						[ new_key, data[old_key] ]
					}.to_h
				]
			}.to_h 
		}.reduce(:deep_merge)
	end



# hash each 后变成了String？？？？
# ？？？？？？？因为redis 该方法存hash 一次仅一层x{x{''}}





	# { one_hour_rain: ['SUM_PRE'], last_3_hours_sum_rain: ['SUM_PRE_1H'] }
	# { one_hour_rain:[ 'SUM_PRE', '...' ], last_2_hours_sum_rain: ['SUM_PRE_1H'] }
	def self.sum_data_in_mulit_redis_data options={}, result_key
		operation=Proc.new {|ary| nil.in?(ary) ? '-' : ary.map(&:to_f).reduce(:+)}
		station_name_list = ["农业中心", "西部渔村", "佘山", "松江", "九亭", "车墩", "天马山", "泗泾", "泖港", "五厍", "桐泾", "叶榭", "浦南花卉", "石湖荡", "新桥", "新浜", "第一中学", "泰晤士小镇", "永丰街道", "松江工业区"]

		output = station_name_list.map{ |station_name| [ station_name, [] ]}.to_h
		options.each {|redis_key, column_ary|
			$redis.get_cimiss_hash(redis_key).each_pair { |station_name, val|
				
				column_ary.each { |column|
						output[station_name]&.<< val[column]
					}
			}
		}
		output.each { |station_name, val_ary| 
			p val_ary
			output[station_name] = { result_key => operation.call(val_ary)} 
			# output[station_name] = { result_key => val_ary} 
		}
		output
	end

	# check_corr_id(val.**last**.except('Station_Name'))
	# [{"Station_Name"=>"天马山", "Q_PRE_1H"=>"0", "SUM_PRE_1H"=>"23.90", "COUNT_PRE_1H"=>"23.00"}, {"Station_Name"=>"天马山", "Q_PRE_1H"=>"1", "SUM_PRE_1H"=>"1.00", "COUNT_PRE_1H"=>"1.00"}]
	# [{"Station_Name"=>"新桥", "Q_PRE_1H"=>"1", "SUM_PRE_1H"=>"0.10", "COUNT_PRE_1H"=>"1.00"}, {"Station_Name"=>"新桥", "Q_PRE_1H"=>"0", "SUM_PRE_1H"=>"21.90", "COUNT_PRE_1H"=>"23.00"}]
 	# 旧数据源 cimiss数据源均可转换
	def last_data_parse body
		data = {}
		(body&.[]('DS') || body).group_by { |item| 
			item['Station_Name'] || item['name'] # 旧数据源
			}.each { |station_name, val|
				# last 得到最新数据
				  p '---'
				  p  val
				  p '---'
					p data[station_name] =
					# 临时 对Q_PRE_1H(单数据数据源)
						check_corr_id(val.select{|x| x["Q_PRE_1H"].nil? ||  x["Q_PRE_1H"].in?(['0', '3', '4']) }.last.except('Station_Name'))
					}
		data
	end

	class << self
		def do_join
			# p '-------self.new.sum_multi_mins_rain'
			# p SimpleCimissRain.new.sum_multi_mins_rain
			# p '-------self.new.sum_last_multi_hours_rain 3'
			# p SimpleCimissRain.new.sum_last_multi_hours_rain 3
			# p '-------self.new.sum_last_multi_hours_rain 6'
			# p SimpleCimissRain.new.sum_last_multi_hours_rain 6
			# p '-------self.new.sum_last_multi_hours_rain 24'
			# p SimpleCimissRain.new.sum_last_multi_hours_rain 24
			# options = {
			# 	one_hour_rain: { 'SUM_PRE' => 'one_hour_rain'},
			# 	last_3_hours_sum_rain: { 'SUM_PRE_1H' => 'three_hour_rain'},
			# 	last_6_hours_sum_rain: { 'SUM_PRE_1H' => 'six_hour_rain'},
			# 	last_24_hours_sum_rain: { 'SUM_PRE_1H' => 'one_day1_rain'},
			# 	last_24_hours_sum_rain: { 'SUM_PRE_1H' => 'one_day2_rain'},
			# 	# 同redis key 同 column 但 不同目标对象 处理一下！！
			# 	# 
			# } 
			options = {
				one_hour_rain: { 'one_hour_rain' => 'SUM_PRE'},
				last_3_hours_sum_rain: { 'three_hour_rain' => 'SUM_PRE_1H'},
				last_6_hours_sum_rain: { 'six_hour_rain' => 'SUM_PRE_1H'},
				last_24_hours_sum_rain: { 
					'one_day1_rain' => 'SUM_PRE_1H', 
					'one_day2_rain' => 'SUM_PRE_1H'
					},
				# 同redis key 同 column 但 不同目标对象 处理一下！！
				# 
			} 
			fix_name_option = {
				'桐泾' => '洞泾',
				'松江' => '正泰科沁苑'
			}
			p '#########fix_name###'
			oooo = self.join_and_rename(options)
			oo = oooo.clone 
			oooo.each do |name, data|
				if fix_name_option[name]
					oo[fix_name_option[name]] = oo[name]
					oo.except! [name]
				end
			end

			p oo

			

		end
	  # change = { 'one_hour_rain' => 'Sum_PRE' }
	  # old_data is an array of hash
		# [{
		#   "report_date": "2017-03-18 08:40",
		#   "sitenumber": "98206",
		#   "name": "新浜",
		#   "max_tempe": 11.1,
		#   "one_hour_rain": 0,
		# }, ...]
	  # new_data is an hash 
	  # { 
		#  	"第一中学"=>{"Station_Id_d"=>"655759", "REP_CORR_ID"=>"000", "Sum_PRE"=>"0"},
		#  	"车墩" => {...},
		#  }

 # 	原思路
 # 	new_data为上述标准格式..
		def replace_old_data old_data, new_data, change={}
			# join + rename
			#  但是没解决多次cimiss 请求同名字段
			# cimiss_keyword = ['REP', 'REP_1h']
			output = old_data.clone
			old_data.map do |one_station_data|
				change.each do |old_key, new_key|
					one_station_data[old_key] = new_data[one_station_data['name']][new_key] 
				end
				one_station_data
			end
		end
 # 新？
 # 替换 采用 hash replace
 		# def replace
 			
 		# end
 		def replace old_data, new_data

    new_data = self.do_join
			old_data.map { |one_station_data|
				p '===old==='
				p one_station_data
				p '--name'
				p one_station_data['name']
				p '=new====='
				p new_data[one_station_data['name']]

				one_station_data&.merge new_data[one_station_data['name']] || {}

			}
 		end

	end
end
# cimiss 站名 ["车墩", "第一中学", "松江工业区", "石湖荡", "泰晤士小镇", "五厍", "*桐泾", "西部渔村", "农业中心", "叶榭", "泖港", "新浜", "永丰街道", "浦南花卉", "泗泾", "松江", "佘山", "九亭", "新桥", "天马山"]
#   相比原数据源多出 ["第一中学", "松江工业区", "浦南花卉", "佘山"]
#   ["第一中学", "松江工业区"] 雨量站
#   名字错误 ["桐泾"]
#   名字更改 '松江'-> 正泰科沁苑
# 原 数据源站名  ['松江', '新浜', '五厍', '九亭', '叶榭', '天马山', '新桥', '车墩', '洞泾', '农业中心', '永丰街道', '西部渔村', '泖港', '石湖荡', '泰晤士小镇', '泗泾']
# 	
# 输出
# ["洞泾", "农业中心", "叶榭", "佘山", "石湖荡", "浦南花卉", "泰晤士小镇", "泗泾", "永丰街道", "九亭", "西部渔村", "泖港", "新桥", "新浜", "车墩", "正泰科沁苑", "天马山", "五厍"]
# different ["洞泾", "正泰科沁苑", "第一中学", "松江工业区", "*桐泾", "*c松江"]