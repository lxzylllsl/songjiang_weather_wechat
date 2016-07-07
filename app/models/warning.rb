class Warning

  class CityWarning
    include NetworkMiddleware  

    def initialize
      @root = self.class.name.to_s
      super
    end

    def fetch
      response = get_data({method: 'get', data: {
        appid: @appid,
        appkey: @appkey
      }}, {})
      _result = []
      response.fetch('data', []).each do |item|
        # unless item['level'].eql?('解除')
          item['icon'] = Warning.get_image_pic(item['type'], item['level'])
          _result << item
        # end
      end
      
      _result.each do |item|
        
      end
      p _result
      _result
    end
  end

  def self.get_image_pic(type, level)
    image_pic = ""
    warning_type = {
      "台风" => "a",
      "暴雨" => "b",
      "高温" => "c",
      "寒潮" => "d",
      "大雾" => "e",
      "雷电" => "f",
      "大风" => "g",
      "沙尘暴" => "h",
      "冰雹" => "i",
      "暴雪" => "j",
      "道路结冰" => "k",
      "干旱" => "l",
      "霜冻" => "m",
      "霾" => "n",
      "臭氧" => "o"
    }
    warning_level = {
      "蓝色" => 1,
      "黄色" => 2,
      "橙色" => 3,
      "红色" => 4
    }
    type = warning_type[type]
    level = warning_level[level] || 2
    "#{type}#{level}.png"
  end
end
