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
	def travel_notification travel
		@travel = travel
		@user = travel.user
		mail to: @user.email, subject: "Votre demande de parking sur TravelerCar"
	end

end
