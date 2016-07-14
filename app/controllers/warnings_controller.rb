class WarningsController < ApplicationController
  
  def index
    @warnings = Warning::CityWarning.new.fetch
    
    @songjiang_warnings = Warning::SongjiangWarning.new.fetch
  end
end
