if  Rails.env.production?

	# Using SendGrid for Heroku. Source: https://devcenter.heroku.com/articles/sendgrid
	ActionMailer::Base.smtp_settings ={
			:address        => 'smtp.sendgrid.net',
			:port           => '587',
			:authentication => "plain",
			:user_name      => ENV['SENDGRID_USERNAME'],
			:password       => ENV['SENDGRID_PASSWORD'],
			:domain         => 'travelercar-test.heroku.com',
			:enable_starttls_auto => true
	}

else

	# Using gmail for dev and testing.
	ActionMailer::Base.smtp_settings ={
			:address => "smtp.gmail.com",
			:port => 587,
			:user_name => "test.smtp@adventori.com",
			:password => "smtp;test",
			:authentication => "plain",
			:enable_starttls_auto => true
	}
end

if Rails.env.development?
	class OverrideMailRecipient
		def self.delivering_email(mail)
			mail.to = "htaidirt+tc_admin@gmail.com"
		end
	end
	AdminMailer.register_interceptor(OverrideMailRecipient)
end

# ActionMailer::Base.default_url_options = {:host => ENV['HOST'], :locale => I18n.locale} # Your app URL. E.g: myapp.herokuapp.com
