class Typhoon

  class TyphoonList
    include NetworkMiddleware  

    def initialize
      @root = self.class.name.to_s
      super
    end

    def fetch
      _result = get_data({method: 'get', data: {
        appid: @appid,
        appkey: @appkey,
        area: '松江'
      }}, {})
      _result.fetch('data', {})
    end
  end

  class TyphoonDetail
    include NetworkMiddleware  

    def initialize
      @root = self.class.name.to_s
      super
    end

    def fetch(id)
      @api_path = @api_path + id
      _result = get_data({method: 'get', data: {
        appid: @appid,
        appkey: @appkey,
      }}, {})
      
    end
  end
end
