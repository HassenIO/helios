class ParkingsController < ApplicationController

	def index	
	end

	def create
		@parking = Parking.new params[:parking]

		if @parking.save
			AdminMailer.parking_request(@parking).deliver
		else
			flash[:error] = "Erreur dans votre formulaire"
			render "index"
		end
	end
end
