class UserMailer < ActionMailer::Base

	layout "mailer"

	default from: ENV["MAILER_SUPPORT"]
	# default :from => "contact@travelercar.com"



	# Congratulate the new user after email confirmation or facebook signup.
	def welcome user
		@user = user

		mail to: @user.email, subject: "Bienvenue sur TravelerCar"
	end

	# Notify the user about a new carpark request
	def travel_new travel
		@travel = travel
		@user = travel.user

		mail to: @user.email, subject: "Votre demande de parking sur TravelerCar"
	end

	# Notify the user when he changes a carpark request
	def travel_update travel
		@travel = travel
		@user = travel.user

		mail to: @user.email, subject: "Modification de votre demande de parking sur TravelerCar"
	end

	# Notify the user about their new Rent
	def rent_new rent, email
		@rent = rent
		@user = rent.user

		mail to: email, subject: "Confirmation de votre location TrevelerCar"
	end

end
