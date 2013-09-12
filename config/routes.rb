TravelerCar::Application.routes.draw do

	authenticated :user do
		root to: "dashboards#index"
	end

	unauthenticated :user do
		root to: "home#index"
	end

	ActiveAdmin.routes(self)

	resources :home # Used only for dev (Equivalent of WordPress on prod)

	scope "/:locale", :constraints => {:locale => /[a-z]{2}(-[A-Z]{2})?/} do

		devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations" }

		resources :dashboards
		resources :invitation_requests

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

	match "notifications" => "notifications#index"

end