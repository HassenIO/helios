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




	# def index

	# 	#http://www.example.com/notifications.php?operation={%22TransactionID%22:18,...}

	# 	operation = params[:operation]
	# 	#plusieurs transaction ?
	# 	transaction_id = operation['TransactionID']


	# 	operation = Leetchi::Operation.get(transaction_id)
	# 	#si on a que des contributions ?

	# 	if operation["TransactionType"] == "Contribution"
	# 		payment = Payment.find_by_contribution_id(transaction_id)

	# 		unless payment.nil?
	# 			payment.check_payment
	# 		end

	# 	end

	# 	# Operation object
	# 	#{
	# 	#    "UserID" : 185530,
	# 	#    "WalletID" : 0,
	# 	#    "Amount" : 5000,
	# 	#    "TransactionType" : "Contribution",
	# 	#    "TransactionID" : 196900,
	# 	#    "ID" : 196900,
	# 	#    "Tag" : "Custom data",
	# 	#    "CreationDate" : 1362592859,
	# 	#    "UpdateDate" : 1362592881
	# 	#}

	# end

end
