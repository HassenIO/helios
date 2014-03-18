class AdminMailer < ActionMailer::Base

	default from: ENV["MAILER_SUPPORT"], to: ENV["MAILER_ADMIN"]

	def parking_request parking
		@parking = parking
		mail(:subject => "Nouvelle demande de parking payant")
	end

	def parking_confirmation parking
		@parking = parking
		mail(subject: "Votre réservation de parking helios", template_name: "parking_confirmation_#{parking.airport}")
	end

	def rent_notification rent
		@user = rent.user
		@url  = user_rent_url(I18n.locale, rent.user, rent)
		@admin_url  = admin_rent_url(rent)
		mail(:subject => "New rent on helios.com")
	end

	def travel_new travel
		@user = travel.user
		@url  = user_travel_url(I18n.locale, travel.user, travel)
		@admin_url  = admin_travel_url(travel)
		mail( :subject => "New parking on helios.com")
	end

	def travel_update travel
		@user = travel.user
		@url  = user_travel_url(I18n.locale, travel.user, travel)
		@admin_url  = admin_travel_url(travel)
		mail( :subject => "Update on parking request - helios.com")
	end

	def rent_paid params
		@params = params
		mail( subject: "New payment made - PayPal params" )
	end

end
