class NotificationsController < ApplicationController
	
	protect_from_forgery :except => [:payment]

	def payment
		rent = Rent.find_by_id params[:id]

		# Notify the admin and user by email
		UserMailer.rent_new(rent, rent.user.email).deliver
		AdminMailer.rent_paid(params).deliver

		# Update the Travel status of the car
		travel = rent.travel
		travel.status = :rent
		travel.save( validate: false )

		# Complete the Rent data with payment paramsters
		rent.status = :paid
		rent.transaction_id = params[:txn_id]
		rent.payment_params = params
		rent.save( validate: false )

		# Render nothing (status code 200)
		render nothing: true, status: 200
	end

end
