Rails.application.routes.draw do
  mount WeixinRailsMiddleware::Engine, at: "/"
  resources :followers

  resources :weather_forecast, only: [:index] do
    collection do
      get :locate
    end
  end

  resources :air_quality, only: [:index]
  resources :radar_satellis, only: [:show] do
    collection do
      get :locate
    end
  end
  
  resources :weather_essential do
    collection do
      get :locate
    end
  end
  
  resources :auto_stations do
    collection do 
      get :history
    end
  end

  resources :typhoon 
  
  namespace :admin do
    resources :page_list, only: [:index]
  end
end
