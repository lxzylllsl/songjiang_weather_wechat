class TyphoonController < ApplicationController
  layout 'typhoon'

  def index
    @typhoon_list = Typhoon::TyphoonList.new.fetch
  end

  def show
    
  end
end
