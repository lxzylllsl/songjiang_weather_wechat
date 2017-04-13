class RadarSatellisController < ApplicationController
  layout 'radar'
  
  def locate
    
  end

  def index
    @nh_radar_images = Radar.new.locate location_params
    @qp_radar_images = Radar::QpRadar.new.locate location_params
    @fy2e_cloud_img = Image::CloudData.new.fetch
    @fy2g_cloud_img = Image::CloudFy2gData.new.fetch
  end

  def demo
    
  end
  
  private
  def location_params
    params.permit(:lon, :lat)
  end
end
