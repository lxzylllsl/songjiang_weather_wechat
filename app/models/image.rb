class Image

  class CloudData
    include NetworkMiddleware

    def initialize
      @root = self.class.name.to_s
      super
    end

    def fetch
      response = get_data({method: 'get', data: {
        appid: @appid,
        appkey: @appkey,
        type: 'cloud_fy2e'
      }}, {});
      _result = response['result']
      _result.sort! { |a, b| a['datetime'] <=> b['datetime'] }
    end
  end

  class CloudFy2gData
    include NetworkMiddleware

    def initialize
      @root = self.class.name.to_s
      super
    end

    def fetch
      response = get_data({method: 'get', data: {
        appid: @appid,
        appkey: @appkey,
        type: 'cloud_fy2g'
      }}, {});
      _result = response['result']
      _result.sort! { |a, b| a['datetime'] <=> b['datetime'] }
    end
  end

  class DemData
    include NetworkMiddleware

    def initialize
      @root = self.class.name.to_s
      super
    end

    def fetch
      response = get_data({method: 'get', data: {
        appid: @appid,
        appkey: @appkey
      }}, {});
      _result = response['list']
    end
  end
end
