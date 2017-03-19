module TimeStringHelper
	Time.class_eval do 
		# strftime("%Y-%m-%d %H:%M:%S")

		def oclock_string
			self.strftime("%Y%m%d%H00")
		end

		# 自动站十分
		def ten_mins_string
			self.strftime("%Y%m%d%H#{ self.min / 10 }0")
		end
	end
end