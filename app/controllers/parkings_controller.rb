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

		if @parking.save
			redirect_to @parking.paypal_url( parkings_success_url(@parking.id), parkings_ipn_url(@parking.id) )
		else
			flash[:error] = "Erreur(s) dans votre formulaire"
			render "index"
		end
	end

	def ipn
		@parking = Parking.find_by_id params[:id]
		
		# @parking.dropoff = Time.strptime @parking.dropoff, "%Y-%m-%d %H:%M:00.000000"
		# @parking.pickup = Time.strptime @parking.pickup, "%Y-%m-%d %H:%M:00.000000"
		@parking.paid = true
		@parking.status = "paid"
		@parking.save
		
		AdminMailer.parking_request(@parking).deliver
		AdminMailer.parking_confirmation(@parking).deliver

		render nothing: true
	end

	def success
		@parking = Parking.find_by_id params[:id]
	end
end
