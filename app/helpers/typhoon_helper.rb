module TyphoonHelper

  def transform_level val
    idx = 0
    if (val >= 10.8 && val <= 17.1) 
      idx = 1
    elsif (val >= 17.2 && val <= 24.4) 
      idx = 2
    elsif (val >= 24.5 && val <= 32.6) 
      idx = 3
    elsif (val >= 32.7 && val <= 41.4) 
      idx = 4
    elsif (val >= 41.5 && val <= 50.9) 
      idx = 5
    elsif (val >= 51) 
      idx = 6
    else
      idx = 0
    end
    level_names = ['','热带低压', '热带风暴', '强热带风暴', '台风', '强台风', '超强台风']
    return level_names[idx]
  end

end
