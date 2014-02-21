class ParkingsController < ApplicationController

	def index
		@parking = Parking.new
	end

	def show
		@parking = Parking.new airport: params[:id]
		render "index"
	end

	def create
		@parking = Parking.new params[:parking]
		pickup_time = @parking.pickup.split(" ")[1]
		dropoff_time = @parking.dropoff.split(" ")[1]

		if @parking.save
			if @parking.airport == "CDG" && ((pickup_time >= "00:00" && pickup_time < "05:00") || (dropoff_time >= "00:00" && dropoff_time < "05:00"))
				flash[:error] = "Désolé, mais aucune navette n'est disponible entre minuit et 05:00 du matin."
				render "index"
			elsif @parking.airport == "ORY" && ((pickup_time >= "00:00" && pickup_time < "06:00") || (dropoff_time >= "00:00" && dropoff_time < "06:00"))
				flash[:error] = "Désolé, mais aucune navette n'est disponible entre minuit et 06:00 du matin."
				render "index"
			else
				redirect_to @parking.paypal_url( parkings_success_url(@parking.id), parkings_ipn_url(@parking.id) )
			end
		else
			flash[:error] = "Erreur(s) dans votre formulaire"
			render "index"
		end
	end
	
	def update
		create
	end
	
	def ipn
		@parking = Parking.find_by_id params[:id]
		
		@parking.status = "paid"
		if @parking.save
			AdminMailer.parking_request(@parking).deliver
			AdminMailer.parking_confirmation(@parking).deliver
			UserMailer.parking_confirmation(@parking).deliver

			render nothing: true, status: 200
		else
			render nothing: true, status: 500
		end
	end

	def success
		@parking = Parking.find_by_id params[:id]
	end
end
