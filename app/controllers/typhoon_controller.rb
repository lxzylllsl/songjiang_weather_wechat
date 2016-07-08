class TyphoonController < ApplicationController
  layout 'typhoon'

  def index
    # 计数器
    @visitor = params[:v]
    $redis.lpush "read_typhoon", {time: DateTime.now, visitor: @visitor}
    @radar_echo = Radar::RadarEcho.new.fetch['img']
    # @typhoon = Typhoon::TyphoonDetail.new.fetch('-')
  end

  def show
    
  end
end
