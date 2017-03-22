class	Time
	# strftime("%Y-%m-%d %H:%M:%S")

	def oclock
		self.strftime("%Y%m%d%H").to_time
	end

	def one_hour_rain_start
		( self - 1.minutes ).strftime("%Y%m%d%H").to_time
	end

	# 自动站十分
	def ten_mins_string
		self.strftime("%Y%m%d%H#{ self.min / 10 }0")
	end

	def min_string
		self.strftime("%Y%m%d%H%M")
	end

	def query_format
		self.gmtime.strftime("%Y%m%d%H%M%S")
	end

end