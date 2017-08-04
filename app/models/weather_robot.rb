class WeatherRobot
	class << self
		def get_reply question
			require 'uri'
			require 'net/http'

			uri = URI('http://xiaoi.weather-huayun.com/ask.do')
			req = Net::HTTP::Post.new(uri)
			req.set_form_data( platform: "weixin", question: question )
			req['X-Auth'] = create_x_auth
			begin
				Timeout.timeout(3) do
					res = Net::HTTP.start(uri.hostname, uri.port) do |http|
						http.request(req)
					end
					res.body.strip
				end
			rescue Exception
				nil
			end
		end
		
	private
		def create_x_auth
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

			_x_auth = "app_key=\"#{app_key}\",nonce=\"#{nonce}\",signature=\"#{ha3}\""
		end
	end
end