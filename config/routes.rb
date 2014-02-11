TravelerCar::Application.routes.draw do

	root to: "dashboards#index"

	ActiveAdmin.routes(self)
	namespace :admin_powers do
		get "new_travel_email/:id", action: "new_travel_email", as: "new_travel_email"
		get "duplicate_travel/:id", action: "duplicate_travel", as: "duplicate_travel"
	end

	scope "/:locale", :constraints => {:locale => /[a-z]{2}(-[A-Z]{2})?/} do

		root to: "dashboards#index"

		devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations" }

		resources :dashboards

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

	match "nav" => "navigations#index"
	match "log" => "navigations#log"

	resources :notifications do
		post :payment, on: :member # Used for IPN
	end

	resources :parkings
	get '/parkings/success/:id' => 'parkings#success', as: 'parkings_success'

	get "api/cars", to: "search#api_search", as: "api_search"
	get '/api/:token/travel/:travel', to: 'search#api_redirect', as: 'api_redirect'

end
