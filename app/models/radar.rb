class Radar
  # @radar_lon = 120.95778
  # @radar_lat = 31.075
  @radar_lon = 121.88194
  @radar_lat = 31.00694

  def self.locate location
    _lon = location[:lon].to_f
    _lat = location[:lat].to_f

    offset_x, offset_y = calculate _lon, _lat
    list = $redis.lrange "radar_image_cache", 0, 9
    radar_images = []
    list.each do |item|
      _item = MultiJson.load(item)

      image = Magick::Image.read(_item['img']).first

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
      file_name = "radar/#{_item['time']}_#{_lon}_#{_lat}.png"
      image.write("public/images/#{file_name}")
      radar_images << {datetime: _item['time'], url: file_name}
    end
    radar_images.reverse
  end

  def self.process
    RadarImageProcess.new.fetch
  end

  class RadarImageProcess
    include NetworkMiddleware

    def initialize
      @root = self.class.name.to_s
      @redis_key = "radar_image_cache"
      super
    end

    def fetch
      response = get_data({method: 'get', data: {
        appid: @appid,
        appkey: @appkey,
        type: 'nh_radar'
      }}, {});
      _result = response['result']
      if _result.present?
        new_img = $redis.lindex(@redis_key, 0)
        new_img_hash = MultiJson.load(new_img) rescue {}
        _result.each do |item|
          # p "datetime: #{item['datetime'].to_i}"
          # p "img: #{new_img_hash['time'].to_i}"
          if item['datetime'].to_i > (new_img_hash['time'].to_i || 0)
            @api_path = item['url']
            _img = get_data({method: 'get', type: 'image'})
            if _img.status == 200
              write_image _img.body, item['datetime']
            end
          end
        end

        $redis.ltrim @redis_key, 0, 75
      end
    end

    def write_image data, name
      _time = DateTime.parse(name).strftime("%F")
      file_path = "tmp/radar/#{_time}"
      FileUtils.makedirs(file_path) unless File.exist?(file_path)
      file = File.new("#{file_path}/#{name}.png", 'wb')
      file.write(data)
      file.close
      $redis.lpush @redis_key, {img: "#{file_path}/#{name}.png", time: name}.to_json
    end
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
    _lon_idx = (lon - @radar_lon) / 0.0102
    _lat_idx = (@radar_lat - lat) / 0.0072
    [_lon_idx, _lat_idx]
  end

end
