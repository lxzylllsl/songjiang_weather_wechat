Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users, controllers: {
    sessions: "users/sessions"
  }
  
  mount WeixinRailsMiddleware::Engine, at: "/"
  
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
  resources :warnings, only: [:index]
  resources :articles, only: [:index, :show]

  namespace :admin do
    root to: 'home#index'
    resources :page_list, only: [:index]
    resources :articles
    resources :users
    resources :followers
  end
end
