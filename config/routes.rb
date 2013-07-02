TravelerCar::Application.routes.draw do

  root :controller => "home", :action => "index"

  match "notifications" => "notifications#index"

    scope "/:locale", :constraints => {:locale => /[a-z]{2}(-[A-Z]{2})?/} do

      root :controller => "home", :action => "index"

      devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}

      resources :users do
        resources :travels do
          get 'cgv', :on => :member
        end
        resources :cars
        resources :rents do
          resource :payment
          get 'cgv', :on => :member
        end
      end
      resources :rents, only: [:new]
      resources :travels, only: [:new]

      authenticated :user do
        match "/travels", to: redirect { |p, req| "/#{p[:locale]}/users/#{req.env["warden"].user(:user).id}/travels/new" }, :as => 'travels'
      end

      unauthenticated :user do
        match '/travels(/:action)' => 'anonymous_travels', :as => 'travels'
      end

      match '/search(/:action)' => 'search', :as => 'search'

    end

    ActiveAdmin.routes(self)

end