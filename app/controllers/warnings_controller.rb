class WarningsController < ApplicationController
  
  def index
    @warnings = Warning::CityWarning.new.fetch
  end
end
