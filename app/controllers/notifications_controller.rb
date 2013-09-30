class NotificationsController < ApplicationController
	
	protect_from_forgery :except => [:payment]

	def payment
		rent = Rent.find params[:id]

		travel = rent.travel
		travel.status = :rent
		travel.save( validate: false )

		rent.status = :paid
		rent.transaction_id = params[:txn_id]
		rent.payment_params = params
		rent.save

		render nothing: true
	end

end
