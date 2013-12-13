class NotificationsController < ApplicationController

	protect_from_forgery :except => [:payment]

	def payment
		# TODO
		# - Check IPN type: Payment vs. Refund
		# See https://www.paypal.com/fr/cgi-bin/webscr?cmd=p/acc/ipn-info-outside

		# The IPN should be for the Completed payment, not the refund
		if params[:payment_status] == "Completed"

			# Check if the payment transaction_id exists, to avoid ducplicate payment
			if Rent.find_by_transaction_id( params[:txn_id] ).nil?

				rent = Rent.find_by_id params[:id]

				# Notify the admin and user by email
				UserMailer.rent_new(rent, rent.user.email).deliver
				AdminMailer.rent_paid( params ).deliver

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

			else
				# The payment was already made (duplicate)
				render text: "duplicate payment", status: 200
			end

		else
			# The IPN is a Refund
			render text: "refund", status: 200
		end

	end

end
