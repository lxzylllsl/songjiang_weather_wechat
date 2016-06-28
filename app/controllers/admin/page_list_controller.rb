module Admin
  class PageListController < ApplicationController
    
    def index
      @list = []
      @list << {name: '天气首页', url: '../weather_forecast/locate'}
      @list << {name: '空气质量', url: '../air_quality'}
      @list << {name: '雷达卫星', url: '../../radar_satellis/locate'}
    end
    
  end
end
