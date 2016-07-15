class AutoStationsController < ApplicationController

  def history
    _type = params[:type]
    _sitenumber = params[:sitenumber]
    data = AutoStation::History.new.fetch _type, _sitenumber
    @result = []
    data.each do |e|
      @result.unshift({
        type: type_changer(_type),
        datetime: e['datetime'].split(' ')[-1],
        data: e['data']
      })
    end
  end

  private
  def type_changer type
    _type = ''
    case type
    when 'tempe'
      _type = '温度'
    when 'wind'
      _type = '风'
    when 'rain'
      _type = '降水'
    end
    _type
  end
end
