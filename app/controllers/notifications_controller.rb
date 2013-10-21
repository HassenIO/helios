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

		UserMailer.rent_new(rent, rent.user.email).deliver
		UserMailer.rent_new(rent, ENV["MAILER_ADMIN"]).deliver

		render nothing: true
	end

end
