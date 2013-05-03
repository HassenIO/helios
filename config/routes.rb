TravelerCar::Application.routes.draw do

  root :controller => "home", :action => "index"

  scope "/:locale", :constraints => {:locale=> /[a-z]{2}(-[A-Z]{2})?/ } do

    root :controller => "home", :action => "index"

    devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}

    resources :users do
      resources :travels
      resources :cars
      resources :rents
    end
    resources :rents, only: [:new]
    resources :travels, only: [:new]

    namespace :admin do
      resources :travels
    end

    authenticated :user do
      get "/travels", to: redirect { |p, req| "/#{p[:locale]}/users/#{req.env["warden"].user(:user).id}/travels/new" }
    end

    unauthenticated :user do
      get '/travels', to: 'anonymous_travels#new'
    end

    match ':controller(/:action(/:id))'
  end




end