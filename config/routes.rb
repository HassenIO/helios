TravelerCar::Application.routes.draw do

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => "home#index"

  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}


  resources :users do
    resources :travels
    resources :cars
  end


  authenticated :user do
    match "/travels" => redirect {|p, req| "/users/#{req.env["warden"].user(:user).id}/travels"}
  end

  unauthenticated :user do
    match "travels" => "anonymous_travels#new"
  end


  resource :anonymous_travels do
    get 'checkout'
  end


end