class WeatherRobot
	def self.get_reply question
		require 'digest/sha1'
		app_key = 'qxj_DAMy5MrR9t0P'
		app_secret = 'OpVOWelokGrMkyqAkFzI'
		realm = "xiaoi.com" 
		method = "POST"
		_uri = "/ask.do" 
		begin
			nonce = ''
			chars = ("0".."9").to_a 
			1.upto(40) { |i| nonce << chars[rand(chars.size-1)] }
		end
		ha1 = Digest::SHA1.hexdigest("#{app_key}:#{realm}:#{app_secret}")
		ha2 = Digest::SHA1.hexdigest("#{method}:#{_uri}")
		ha3 = Digest::SHA1.hexdigest("#{ha1}:#{nonce}:#{ha2}")

		puts _x_auth = "app_key=\"#{app_key}\",nonce=\"#{nonce}\",signature=\"#{ha3}\""
		require 'uri'
		require 'net/http'
		require 'net/https'

		uri = URI.parse("http://www.weather-huayun.com/ask.do")
		https = Net::HTTP.new(uri.host,uri.port)
		# https.use_ssl = true
		req = Net::HTTP::Post.new(uri.path + "?platform=weixin&question=#{question}", initheader = {'X-Auth' => _x_auth})
		# req['foo'] = 'bar'
		# req.body = {
		#  	"platform" => "weixin"
		# }
		res = https.request(req)
		# puts "Response #{res.code} #{res.message}: #{res.body}"
		res.body.strip
	end
end