class Cimiss

	def self.get
    require 'uri'
    require 'net/http'
    require 'net/https'

    time = ( Time.now.gmtime - 3.minute ).strftime("%Y%m%d%H%M") + "00"
    time2 = Time.now.gmtime.strftime("%Y%m%d%H%M") + "00"
    # uri = URI.parse("http://t.weather-huayun.com:8080/cimiss-web/api?userId=BCSH_SHSJ_api&pwd=67739161&interfaceId=getSurfEleInRegionByTimeRange&dataCode=SURF_CHN_MAIN_MIN&timeRange=[#{time},#{time2}]&adminCodes=310117&elements=Station_Name,Datetime,TEM,WIN_D_Avg_1mi,WIN_S_Avg_1mi,Q_TEM,Q_WIN_D_Avg_1mi,Q_WIN_S_Avg_1mi&dataFormat=json")
    # https = Net::HTTP.new(uri.host,uri.port)
    # _body = nil
    unless $redis.get "cimiss_link" == "flase" 
      _body =  RestClient::Request.execute(
        method: :get, 
        url: "http://t.weather-huayun.com:8080/cimiss-web/api?userId=BCSH_SHSJ_api&pwd=67739161&interfaceId=getSurfEleInRegionByTimeRange&dataCode=SURF_CHN_MAIN_MIN&timeRange=[#{time},#{time2}]&adminCodes=310117&elements=Station_Name,Datetime,TEM,WIN_D_Avg_1mi,WIN_S_Avg_1mi,Q_TEM,Q_WIN_D_Avg_1mi,Q_WIN_S_Avg_1mi&dataFormat=json", 
        timeout: 3) 
    end
    # 
  
    if _body && _ds =  JSON.parse(_body)['DS'] 
      #筛选出最新
      _newest = _ds.group_by{ |i| i['Station_Name']}.values.map { |e| e[ e.length - 1] }

      _output = _newest.map do |item|
        _result = {}
        _result["name"] = item["Station_Name"]
        _result["datetime"] = (item["Datetime"].to_time + 8.hours ).strftime("%Y-%m-%d %H:%M")
        _result["tempe"] = item["Q_TEM"].in?(["0","3","4"]) ? item["TEM"] : nil
        _result["wind_direction"] = item["Q_WIN_D_Avg_1mi"].in?(["0","3","4"]) ? Cimiss.wind_direction(item["WIN_D_Avg_1mi"].to_f) : nil
        _result["wind_speed"] = item["Q_WIN_S_Avg_1mi"].in?(["0","3","4"]) ? Cimiss.wind_level(item["WIN_S_Avg_1mi"].to_f) : nil
        _result
      end
    end
    rescue RestClient::RequestTimeout => e
      return e ? nil  : _output
  end

  # 查询当前站信息 判断是否替换
  def self.getNowStation stations, old_stations
    stations.select{ |o| o["name"] == old_stations['name'] }[0] || old_stations
  end

  # 检查替换站名
  def self.fix_name datas
    datas = [datas] if datas.is_a?(Hash)
    datas.map do |data|
      case data["name"]
      when "桐泾"
        data["name"] = "洞泾"
      when "松江"
        data["name"] = "正泰科沁苑"
      end
      data
    end
  end

  def self.check_link
    time = ( Time.now.gmtime - 3.minute ).strftime("%Y%m%d%H%M") + "00"
    time2 = Time.now.gmtime.strftime("%Y%m%d%H%M") + "00"
    begin
    _body =  RestClient::Request.execute(
        method: :get, 
        url: "http://t.weather-huayun.com:8080/cimiss-web/api?userId=BCSH_SHSJ_api&pwd=67739161&interfaceId=getSurfEleInRegionByTimeRange&dataCode=SURF_CHN_MAIN_MIN&timeRange=[#{time},#{time2}]&adminCodes=310117&elements=Station_Name,Datetime,TEM,WIN_D_Avg_1mi,WIN_S_Avg_1mi,Q_TEM,Q_WIN_D_Avg_1mi,Q_WIN_S_Avg_1mi&dataFormat=json", 
        timeout: 3)
    $redis.set "cimiss_link", "true" unless _body.nil?
    end
    rescue RestClient::RequestTimeout => e
      p "======================================= Cimiss link error ==========================================="
      $redis.set "cimiss_link", "flase"
  end

	def self.wind_direction angle
    case 
    when angle.in?(348.76..360) || angle.in?(0..11.25)
      "北"
    when angle.in?(11.26..33.75)
      "北东北"
    when angle.in?(33.76..56.25)
    	"东北"
    when angle.in?(56.26..78.75)
  	  "东东北"
    when angle.in?(78.76..101.25)
  	  "东"
	  when angle.in?(101.26..123.75)
  	  "东东南"
    when angle.in?(123.76..146.25)
  	  "东南"
	  when angle.in?(146.26..168.75)
  	  "南东南"
    when angle.in?(168.76..191.25)
  	  "南"
    when angle.in?(191.26..213.75)
  	  "南西南"
    when angle.in?(213.76..236.25)
  	  "西南"
    when angle.in?(236.26..258.75)
  	  "西西南"
    when angle.in?(258.76..281.25)
  	  "西"
    when angle.in?(281.26..303.75)
  	  "西西北"
    when angle.in?(303.76..326.25)
  	  "西北"
    when angle.in?(326.26..348.75)
    	"北西北"
  	else
  		"无数据"
    end
  end

  def self.wind_level speed
  	case 
  	when speed.in?(0.0..0.2)
  		"0级"
  	when speed.in?(0.3..1.5)
  		"1级"
		when speed.in?(1.6..3.3)
			"2级"
		when speed.in?(3.4..5.4)
			"3级"
		when speed.in?(5.5..7.9)
			"4级"
		when speed.in?(8.0..10.7)
			"5级"
		when speed.in?(10.8..13.8)
			"6级"
    when speed.in?(13.8..17.1)
      "7级"
		when speed.in?(17.2..20.7)
			"8级"
		when speed.in?(20.8..24.4)
			"9级"
		when speed.in?(24.5..28.4)
			"10级"
		when speed.in?(28.5..32.6)
			"11级"
		when speed.in?(32.7..36.9)
			"12级"
    when speed.in?(36.9..41.4)
      "13级"
		else
			"无数据"		
  	end
  end

end