module NetworkMiddleware

  def initialize
    @connect = Faraday.new(:url => @remote) do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end

  def get_data(params={}, head_params={})
    method = params[:method] || params['method']
    result = send("use_#{method}", params, head_params)
  end

  private
  def use_post(params={}, head_params={})
    request_params = params[:data] || params['data']
    i_type = params[:i_type] || params['i_type'] || 'User'

    response = @connect.post do |request|
      request.url @api_path
      request.headers['Content-Type'] = 'application/json'
      request.headers['Accept'] = 'application/json'
      if head_params.present?
        phone = head_params[:phone] || head_params['phone']
        token = head_params[:token] || head_params['token']
        # token = 'NhqbqsiFr56tCz2DKaYZ'
        request.headers["X-#{i_type}-Phone"] = phone
        request.headers["X-#{i_type}-Token"] = token
      end
      request.body = request_params.to_json
    end
    MultiJson.load(response.body)
  end

  def use_get(params={}, head_params={})
    request_params = params[:data] || params['data']
    # i_type = params[:i_type] || params['i_type'] || 'User'
    response = @connect.get do |request|
      request.url "#{@api_path}?#{request_params}"
      request.headers['Content-Type'] = 'application/json'
      request.headers['Accept'] = 'application/json'
      # if head_params.present?
      #   phone = head_params[:phone] || head_params['phone']
      #   token = head_params[:token] || head_params['token']
      #   request.headers["X-#{i_type}-Phone"] = phone
      #   request.headers["X-#{i_type}-Token"] = token
      # end
      
      # request.body = request_params.to_json
    end
    MultiJson.load(response.body)
  end

end
