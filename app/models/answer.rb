require 'digest/sha1'

class Answer

  def self.ask question
    auths = []
    params1 = %w('qxj_i8RHRmQFcLY7', 'xiaoi.com', 'dJkcZgYnwecfkWHtiT15')
    ha1 = Digest::SHA1.hexdigest(params1.join(':'))
    auths << ha1
    nonce = Rand.random_str 40
    auths << nonce
    ha2 = Digest::SHA1.hexdigest("POST:/ask.do")
    auths << ha2
    auth = Digest::SHA1.hexdigest(auths.join(':'))
    auth_str = "app_key=\"qxj_i8RHRmQFcLY7\", nonce=\"#{nonce}\", signature=\"#{auth}\""
    request_params = {question: question, userId: 'api-ukesekgn', type: 1, auth: auth_str}

    result = AnalyzeAnswer.new.fetch request_params
  end

  class AnalyzeAnswer

    def initialize
      @connect = Faraday.new(:url => 'http://www.weather-huayun.com') do |faraday|
        faraday.request :url_encoded
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
    end

    def fetch params
      response = @connect.post do |request|
        request.url 'ask.do?platform=weixin'
        # request.headers['Content-Type'] = 'application/json'
        request.headers['Accept'] = 'application/json'
        request.headers['X-Auth'] = 'app_key="qxj_i8RHRmQFcLY7", nonce="1f2555786d5fed8ef8e19ea936c3708ccedf", signature="4999da84625aec40c043f17ffc135abe66a27857"'
        # request.headers['X-Auth'] = params.delete(:auth)

        request.body = params.to_json
      end
      p response.body.force_encoding 'utf-8'
      # MultiJson.load(response.body)

    end
  end

end
