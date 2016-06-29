class Warning

  class CityWarning
    include NetworkMiddleware  

    def initialize
      @root = self.class.name.to_s
      super
    end

    def fetch
      _result = get_data({method: 'get', data: {
        appid: @appid,
        appkey: @appkey
      }}, {})
      _result.fetch('data', []) || []
    end
  end
end
