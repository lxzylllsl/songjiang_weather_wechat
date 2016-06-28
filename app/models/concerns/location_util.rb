class LocationUtil
  include NetworkMiddleware

  def initialize
    @api_path = 'geocoder/v2/'
    @remote = 'http://api.map.baidu.com'
    @ak = '200aadcf1ccf720749c79228f9b7fd79'
    super
  end

  def reverse(params)
    lon = params[:lon]
    lat = params[:lat]
    result = get_data({method: 'get', data: "ak=#{@ak}&location=#{lat},#{lon}&coordtype=wgs84ll&output=json&pois=0"},{})
    result['location']
  end
end
