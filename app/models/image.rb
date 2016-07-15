class Image

  class CloudData
    include NetworkMiddleware

    def initialize
      @root = self.class.name.to_s
      super
    end

    def fetch
      _result = get_data({method: 'get', data: {
        appid: @appid,
        appkey: @appkey,
        type: 'cloud'
      }}, {});
      _result['result']
    end
  end
end
