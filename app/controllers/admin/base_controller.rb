module Admin
  class BaseController < ActionController::Base
    before_action :authenticate_user!
    respond_to :html
    layout 'back_end'

    protect_from_forgery with: :exception
  
  end
end
