class NotificationsController < ApplicationController

	protect_from_forgery :except => [:payment]

	def payment
		if params[:payment_status] == "Completed" || ( Rails.env == "development" && params[:payment_status] == "Pending" )

			if Rent.find_by_transaction_id( params[:txn_id] ).nil?

				rent = Rent.find_by_id params[:id]

				travel = rent.travel
				travel.status = :rent
				travel.save( validate: false )

				rent.status = :paid
				rent.transaction_id = params["txn_id"]
				rent.payment_params = params.inspect
				
				if rent.save( validate: false )
					UserMailer.rent_new(rent, rent.user.email).deliver
					AdminMailer.rent_paid( params ).deliver

					render nothing: true, status: 200
				else
					render nothing: true, status: 500
				end

			else
				render text: "duplicated payment", status: 200
			end

		else
			render text: "refund", status: 200
		end

	end

end
