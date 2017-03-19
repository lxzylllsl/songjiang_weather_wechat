module RedisHelper
	# require 'multi_json'
	Redis.class_eval do 

		def set_cimiss_hash key, data, query_time
			self.mapped_hmset key, data
			self.set "report_time_of_#{key}", query_time.query_format
		end

		def get_cimiss_hash key
			self.hgetall(key).map { |key, val| [ key, MultiJson.load(val.gsub('=>',':')) ]}.to_h
		end

	end



end