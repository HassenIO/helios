TravelerCar::Application.routes.draw do

  root :controller => "home", :action => "index"

  scope "/:locale" do

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


  get "/travels", to: redirect("/"+I18n.locale.to_s+'/travels')

  get "/search", to: redirect("/"+I18n.locale.to_s+'/search')

end