class Radar
  @radar_lon = 120.95778
  @radar_lat = 31.075

  def self.locate location
    _lon = location[:lon].to_f
    _lat = location[:lat].to_f
    p "location: >>> #{_lon} <<<  >>> #{_lat} <<<"
    
    offset_x, offset_y = calculate _lon, _lat
    p "offset_x: #{offset_x}, offset_y: #{offset_y}"
    image = Magick::Image.read("smic_qpradar-R-002_201605311143.gif").first
    sj_bg = Magick::Image.read("songjiang.png").first
    sj_bg = sj_bg.resize(45, 47)
    image.composite!(sj_bg, 304, 281, Magick::SrcOverCompositeOp)
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

  private
  def self.calculate lon, lat
    _lon_idx = (lon - @radar_lon) / 0.0092
    _lat_idx = (@radar_lat - lat) / 0.0082
    [_lon_idx, _lat_idx]
  end
end
