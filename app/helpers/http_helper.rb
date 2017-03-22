module HttpHelper
	require 'uri'
  require 'net/http'
	require 'net/https'

	def cimiss_get uri, options={}, timeout=10
		options.each do |key, val| 
			val = val.to_time.query_format if key.to_s.include?('time')
			uri.gsub!("\#{#{key.to_s}}", val)
		end
		# body = Net::HTTP.get(URI.parse(uri))
		body =  RestClient::Request.execute(
        method: :get, 
        url: uri,
        timeout: timeout) 
		p body = JSON.parse(body.force_encoding('utf-8'))
		# body['returnCode']
		body['DS'] ? body : nil # 查询失败/无数据
		##### 报错  here ！！！！！！！！！！####
	rescue RestClient::RequestTimeout => time_out_error
    nil
	end

end