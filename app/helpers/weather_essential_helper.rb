module WeatherEssentialHelper

  def filter val
    val.to_f == 9999.9 ? "-" : val
  end

  # 气象要素 - 气温
  def tempe_color tempe
  	tempe = tempe.to_i
  	if tempe >= 35
  		'text-danger'
  	elsif tempe <= -5
  		'text-primary'
  	end
  end

  # 气象要素 - 风
  def wind_color speed
  	speed = speed.to_i
  	if speed >= 8
  		return 'text-danger'
  	end
  	""
  end

  # 气象要素 - 风速等级转化
  def speed_to_level speed
    speed = speed.to_f
    _left_range = [0.0, 0.3, 1.6, 3.4, 5.5, 8.0, 10.8, 13.9, 17.2, 20.8, 24.5, 28.5, 32.6]
    _right_range = [0.3, 1.6, 3.4, 5.5, 8.0, 10.8, 13.9, 17.2, 20.8, 24.5, 28.5, 32.6, 61]

    level = nil

    _left_range.each_with_index do |num, index|
      if speed >= num && speed < _right_range[index]
        level = index
      end
    end
    level
  end

end
