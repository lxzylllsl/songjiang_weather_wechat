class Radar
  # @radar_lon = 120.95778
  # @radar_lat = 31.075
  @radar_lon = 121.88194
  @radar_lat = 31.00694

  def self.locate location
    _lon = location[:lon].to_f
    _lat = location[:lat].to_f
    p "location: >>> #{_lon} <<<  >>> #{_lat} <<<"
    
    offset_x, offset_y = calculate _lon, _lat
    p "offset_x: #{offset_x}, offset_y: #{offset_y}"
    image = Magick::Image.read("smic_R0-005_201607141746.png").first

    # 松江区域图叠加
    sj_bg = Magick::Image.read("./app/assets/images/songjiang.png").first
    sj_bg = sj_bg.resize(45, 34)
    # 青浦雷达位置
    # image.composite!(sj_bg, 304, 281, Magick::SrcOverCompositeOp)
    # 南汇雷达位置
    image.composite!(sj_bg, 204, 281, Magick::SrcOverCompositeOp)

    red = "#f00"
    tri = Magick::Draw.new

    tri.stroke_width(6)
    tri.fill(red)
    # tri.circle(300, 300, 302,302) #中心点位置
    locate_ptx = 300 + offset_x
    locate_pty = 300 + offset_y
    tri.circle(locate_ptx, locate_pty, locate_ptx + 2, locate_pty + 2)
    tri.draw(image)
    image.write("./app/assets/images/test.gif")
  end

  class RadarEcho
    include NetworkMiddleware

    def initialize
      @root = self.class.name.to_s
      super
    end

    def fetch
      _result = get_data({method: 'get', data: {
        appid: @appid,
        appkey: @appkey
      }}, {});
      _result['result']
    end
  end

  private
  def self.calculate lon, lat
    _lon_idx = (lon - @radar_lon) / 0.0092
    _lat_idx = (@radar_lat - lat) / 0.0082
    [_lon_idx, _lat_idx]
  end

end
