class ParkingsController < ApplicationController

	def index	
	end

	def create
		if (@parking = Parking.create params[:parking])
		else
			flash.now[:error] = "Erreur dans votre formulaire"
			render "index"
			return
		end
	end
end
