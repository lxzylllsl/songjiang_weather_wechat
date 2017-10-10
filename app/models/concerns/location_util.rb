class LocationUtil
  include NetworkMiddleware
  @@EARTH_RADIUS = 6378.137

  def initialize
    @ak = '1QMYSpByhuxTihG8MGnDxPNivzMmnqA9'
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

  def self.get_distance(lon1, lat1, lon2, lat2)
    rad_lat1 = rad lat1
    rad_lat2 = rad lat2
    a = rad_lat1 - rad_lat2
    b = rad(lon1) - rad(lon2)
    _pow1 = Math.sin(a / 2) ** 2
    _pow2 = Math.sin(b / 2) ** 2
    d = Math.sqrt(_pow1 + Math.cos(rad_lat1) * Math.cos(rad_lat2) * _pow2)
    dis = 2 * Math.asin(d)
    dis = dis * @@EARTH_RADIUS
  end

  def self.rad val
    val * 3.1415926 / 180
    # val * BigMath.PI(1).to_f / 180
  end
end
