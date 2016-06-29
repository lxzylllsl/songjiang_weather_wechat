class LocationUtil
  include NetworkMiddleware

  def initialize
    @ak = '200aadcf1ccf720749c79228f9b7fd79'
    @root = self.class.name.to_s
    super
  end

  def reverse(params)
    lon = params[:lon] || params['lon']
    lat = params[:lat] || params['lat']
    @api_path << "?ak=#{@ak}&location=#{lat},#{lon}&coordtype=wgs84ll&output=json&pois=0"
    result = get_data({method: 'get'},{})
    result['location']
  end
end
