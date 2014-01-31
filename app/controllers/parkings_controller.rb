class ParkingsController < ApplicationController

	def index	
	end

	def create
		@parking = Parking.new params[:parking]

		if @parking.save
			
		else
			flash[:error] = "Erreur dans votre formulaire"
			render "index"
		end
	end
end
