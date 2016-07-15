class RadarSatellisController < ApplicationController

  def locate
    
  end

  def show
    _type = params[:id]
    
    if _type.eql?('radar')

    else
    end
    Radar.locate location_params

    @cloud_img = Image::CloudData.new.fetch
  end

  private
  def location_params
    params.permit(:lon, :lat)
  end
end
