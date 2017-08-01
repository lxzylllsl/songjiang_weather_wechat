class TyphoonController < ApplicationController
  layout 'typhoon'

  def index
    # 计数器
    @visitor = params[:v]
    @radar_echo = Radar::RadarEcho.new.fetch['img']
  end

  def show

  end
end
