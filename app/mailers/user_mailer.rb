class UserMailer < ActionMailer::Base

	layout "mailer"

	default from: ENV["MAILER_SUPPORT"]
	# default :from => "contact@travelercar.com"



	# Notify the admin about a new carpark request
	def travel_notification travel
		@travel = travel
		@user = travel.user
		mail( to: @user.email, subject: "Votre demande de parking sur TravelerCar" )
	end

end
