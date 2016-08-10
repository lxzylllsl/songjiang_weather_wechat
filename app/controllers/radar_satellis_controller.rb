class RadarSatellisController < ApplicationController
  layout 'radar'
  
  def locate
    
  end

  def index
    @radar_images = Radar.locate location_params
    @cloud_img = Image::CloudData.new.fetch
  end

  def demo
    
  end
  
  private
  def location_params
    params.permit(:lon, :lat)
  end
end
