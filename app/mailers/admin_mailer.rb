class AdminMailer < ActionMailer::Base

	default from: ENV["MAILER_FROM"], to: ENV["MAILER_FROM"]
	# default :from => "contact@travelercar.com", :to => "support@travelercar.com"

	def rent_notification(rent)
		@user = rent.user
		@url  = user_rent_url(I18n.locale, rent.user, rent)
		@admin_url  = admin_rent_url(rent)
		mail(:subject => "New rent on TravelerCar.com")
	end

	def travel_notification(travel)
		@user = travel.user
		@url  = user_travel_url(I18n.locale, travel.user, travel)
		@admin_url  = admin_travel_url(travel)
		mail( :subject => "New parking on TravelerCar.com")
	end

end
