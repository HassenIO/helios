class AdminMailer < ActionMailer::Base

	default from: ENV["MAILER_SUPPORT"], to: ENV["MAILER_ADMIN"]
	# default :from => "contact@travelercar.com", :to => "support@travelercar.com"


	# Notify the admin about a new Rent
	def rent_notification rent
		@user = rent.user
		@url  = user_rent_url(I18n.locale, rent.user, rent)
		@admin_url  = admin_rent_url(rent)
		mail(:subject => "New rent on TravelerCar.com")
	end

	# Notify the admin about a new carpark request
	def travel_new travel
		@user = travel.user
		@url  = user_travel_url(I18n.locale, travel.user, travel)
		@admin_url  = admin_travel_url(travel)
		mail( :subject => "New parking on TravelerCar.com")
	end

	# Notify the admin about an update on carpark request
	def travel_update travel
		@user = travel.user
		@url  = user_travel_url(I18n.locale, travel.user, travel)
		@admin_url  = admin_travel_url(travel)
		mail( :subject => "Update on parking request - TravelerCar.com")
	end

end
