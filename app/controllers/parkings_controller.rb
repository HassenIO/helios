class ParkingsController < ApplicationController

	def index	
	end

	def create
		@parking = Parking.new params[:parking]

		if @parking.save
			redirect_to @parking.paypal_url parkings_success_url(@parking.id)
		else
			flash[:error] = "Erreur dans votre formulaire"
			render "index"
		end
	end

	def success
		@parking = Parking.find_by_id params[:id]
		
		@parking.dropoff = Time.strptime @parking.dropoff, "%Y-%m-%d %H:%M:00.000000"
		@parking.pickup = Time.strptime @parking.pickup, "%Y-%m-%d %H:%M:00.000000"
		
		AdminMailer.parking_request(@parking).deliver
	end
end
