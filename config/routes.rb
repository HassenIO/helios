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
      match "/travels", to: redirect { |p, req| "/#{p[:locale]}/users/#{req.env["warden"].user(:user).id}/travels/new" }  , :as => 'travels'
    end

    unauthenticated :user do
      match '/travels' => 'anonymous_travels#new', :as => 'travels'
    end

    match '/search(/:action)' => 'search' , :as => 'search'

  end




end