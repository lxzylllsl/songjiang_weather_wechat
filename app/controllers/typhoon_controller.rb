class TyphoonController < ApplicationController
  layout 'typhoon'

  def index
    # 计数器
    $redis.lpush "read_typhoon", {time: DateTime.now}
    # @typhoon = Typhoon::TyphoonDetail.new.fetch('-')
  end

  def show
    
  end
end
