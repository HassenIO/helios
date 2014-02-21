class UserMailer < ActionMailer::Base

	layout "mailer", except: [:parking_confirmation]
	layout "paid_parking", only: [:parking_confirmation]

	default from: ENV["MAILER_SUPPORT"], bcc: ENV["MAILER_ADMIN"]
	

	def parking_confirmation parking
		@parking = parking

		mail to: @parking.email, subject: "Votre réservation de parking TravelerCar"
	end

	def welcome user
		@user = user

		mail to: @user.email, subject: "Bienvenue sur TravelerCar"
	end

	def travel_new travel
		@travel = travel
		@user = travel.user

		mail to: @user.email, subject: "Votre demande de parking sur TravelerCar"
	end

	def travel_update travel
		@travel = travel
		@user = travel.user

		mail to: @user.email, subject: "Modification de votre demande de parking sur TravelerCar"
	end

	def rent_new rent, email
		@rent = rent
		@user = rent.user

		mail to: email, subject: "Confirmation de votre location TrevelerCar"
	end

end
