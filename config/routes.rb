TravelerCar::Application.routes.draw do


  authenticated :user do
    root :to => 'home#index'
  end

  root :to => "home#index"

  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}


  resources :users do
    resources :travels
    resources :cars
    resources :rents
  end

  resources :rents, only: [:new]

  authenticated :user do
    match "/travels" => redirect { |p, req| "/users/#{req.env["warden"].user(:user).id}/travels/new" }
  end

  unauthenticated :user do
    match "/travels" => "anonymous_travels#new"
  end

  match ':controller(/:action(/:id))'

end