class AnonymousTravelsController < ApplicationController

	before_filter :must_sign_in
	before_filter :authenticate_user!

	def index
		@travel = Travel.new

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @travel }
		end
	end

	# POST /travels
	# POST /travels.json
	def create

		session[:travel] = params[:travel]

		redirect_to new_travel_path
	end

end
