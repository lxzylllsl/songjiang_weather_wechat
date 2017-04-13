class Radar
  # 原版 数据
  # 南汇雷达
  # @radar_lon = 121.88194
  # @radar_lat = 31.00694
  # 青浦雷达
  # @radar_lon = 120.95778
  # @radar_lat = 31.075
  def locate location, redis_key=nil
    _lon = location[:lon].to_f
    _lat = location[:lat].to_f
    case 
    when redis_key.nil?
      redis_key = RadarImageProcess.new.instance_variable_get('@redis_key')
      radar = 'nh_radar'
      @scaling = 1
      # 松江区域图 相对图片偏移
      image_coordinate = [ 204, 281 ]
      # 松江区域图 缩放
      sj_bg_size = [45, 34]
      # 雷达中心 相对图片偏移
      circle_center = [300, 300]
      @radar_lon = 121.88194
      @radar_lat = 31.00694 
      
    when redis_key == Radar::RadarImageProcess::QpRadarImageProcess.new.instance_variable_get('@redis_key')
      radar = 'qp_radar'
      @scaling = 0.5
      # 松江区域图 相对图片偏移
      image_coordinate = [ 304.5, 294.5 ]
      # 松江区域图 缩放
      sj_bg_size = [45.0 * @scaling, 34.0 * @scaling]
      # 雷达中心 相对图片偏移
      circle_center = [300, 300]
      @radar_lon = 120.95778
      @radar_lat = 31.075
      
    end
    offset_x, offset_y = calculate _lon, _lat

    list = $redis.lrange redis_key, 0, 9
    lists = list.reverse
    # lists = [{"time" => "2016-08-10","img" => "WechatIMG4.jpeg"},{"time" => "2016-08-10","img" => "WechatIMG4.jpeg"},{"time" => "2016-08-10","img" => "WechatIMG4.jpeg"},{"time" => "2016-08-10","img" => "WechatIMG4.jpeg"},{"time" => "2016-08-10","img" => "WechatIMG4.jpeg"},{"time" => "2016-08-10","img" => "WechatIMG4.jpeg"},{"time" => "2016-08-10","img" => "WechatIMG4.jpeg"},{"time" => "2016-08-10","img" => "WechatIMG4.jpeg"},{"time" => "2016-08-10","img" => "WechatIMG4.jpeg"},{"time" => "2016-08-10","img" => "WechatIMG4.jpeg"}].map{|i| i.to_json}
    radar_images = []
    lists.each do |item|

      _item = MultiJson.load(item)

      image = Magick::Image.read(_item['img']).first
      # image = Magick::Image.read("./app/assets/images/WechatIMG4.jpeg").first
      
      # 松江区域图叠加
      sj_bg = Magick::Image.read("./app/assets/images/songjiang1.png").first
      sj_bg = sj_bg.resize(sj_bg_size[0], sj_bg_size[1])
      image.composite!(sj_bg, image_coordinate[0], image_coordinate[1], Magick::SrcOverCompositeOp)

      red = "#f00"
      tri = Magick::Draw.new

      tri.stroke_width(6)
      tri.fill(red)
      # tri.circle(300, 300, 302,302) #中心点位置
      locate_ptx = circle_center[0] + offset_x
      locate_pty = circle_center[1] + offset_y
      tri.circle(locate_ptx -1 , locate_pty - 1, locate_ptx + 1, locate_pty + 1)
      tri.draw(image)

      file_path = "public/images/radar/#{redis_key}/"
      FileUtils.makedirs(file_path) unless File.exist?(file_path)

      file_name = "#{_item['time']}_#{_lon}_#{_lat}.jpeg"
      file = file_path + file_name
      
      image.write(file)
      url = file_path.gsub('public/', '') + file_name
      radar_images << {datetime: _item['time'], url: url}
    end
    radar_images
  end

  def self.process
    RadarImageProcess.new.fetch
    Radar::RadarImageProcess::QpRadarImageProcess.new.fetch
  end

  class RadarImageProcess
    include NetworkMiddleware

    def initialize
      @root = self.class.name.to_s
      @redis_key = "nh_radar_image_cache"
      super
    end

    def fetch image_type='nh_radar'
      response = get_data({method: 'get', data: {
        appid: @appid,
        appkey: @appkey,
        type: image_type
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
      file_path = "tmp/radar/#{@redis_key}/#{_time}"
      FileUtils.makedirs(file_path) unless File.exist?(file_path)
      file = File.new("#{file_path}/#{name}.png", 'wb')
      file.write(data)
      file.close
      $redis.lpush @redis_key, {img: "#{file_path}/#{name}.png", time: name}.to_json
    end

    def self.clear_histroy_image
      _reserve_date = [Time.zone.today.strftime("%Y-%m-%d")]#, (Time.zone.today - 1 ).strftime("%Y-%m-%d")]

      Dir["tmp/radar/*"].each do |dir|
        FileUtils.rm_rf(dir) unless dir.gsub("tmp/radar/#{@redis_key}",'').in?(_reserve_date)
      end
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
  # def self.calculate lon, lat
  #   _lon_idx = (lon - @radar_lon) / 0.0102
  #   _lat_idx = (@radar_lat - lat) / 0.0072
  #   [_lon_idx, _lat_idx]
  # end
  def calculate lon, lat
    _lon_idx = (lon - @radar_lon) * 118.206320981112 * @scaling
    _lat_idx = (@radar_lat - lat) * 138.888888888889 * @scaling
    [_lon_idx, _lat_idx]
  end
end
