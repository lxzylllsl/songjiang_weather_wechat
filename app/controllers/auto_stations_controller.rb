class AutoStationsController < ApplicationController

  def history
    _type = params[:type]
    _sitenumber = params[:sitenumber]
    data = AutoStation::History.new.fetch _type, _sitenumber
    @result = []
    data.each do |e| 
      @result.unshift({
        name: e['name'],
        datetime: e['datetime'].split(' ')[-1],
        data: e['data']
      })
    end
  end
end
