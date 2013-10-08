ActionMailer::Base.default_url_options = { :host => ENV['HOST'], :locale => I18n.locale }

# Use 1and1 SMTP server
ActionMailer::Base.smtp_settings = {
	:address        => "auth.smtp.1and1.fr",
	:port           => "587",
	:authentication => :plain,
	:user_name      => ENV['1N1_USERNAME'],
	:password       => ENV['1N1_PASSWORD']
}


# In dev env, we create fake users for test
# So, we redirect all mails to these users, into a valid email address
if Rails.env.development?
	class OverrideMailRecipient
		def self.delivering_email(mail)
			mail.to = "htaidirt+tc_dev@gmail.com"
		end
	end
	AdminMailer.register_interceptor(OverrideMailRecipient)
end



# if Rails.env.production?

# 	# We are in production mode -> Use 1and1 SMTP server
# 	ActionMailer::Base.smtp_settings = {
# 		:address        => "auth.smtp.1and1.fr",
# 		:port           => "587",
# 		:authentication => :plain,
# 		:user_name      => ENV['1N1_USERNAME'],
# 		:password       => ENV['1N1_PASSWORD']
# 	}

# else

# 	# We are in dev/test mode -> Use Gmail SMTP Server
# 	ActionMailer::Base.smtp_settings = {
# 		:address => "smtp.gmail.com",
# 		:port => 587,
# 		:user_name => "test.smtp@adventori.com",
# 		:password => "smtp;test",
# 		:authentication => "plain",
# 		:enable_starttls_auto => true
# 	}

# end


# 	# Using SendGrid for Heroku. Source: https://devcenter.heroku.com/articles/sendgrid
# 	ActionMailer::Base.smtp_settings ={
# 			:address        => 'smtp.sendgrid.net',
# 			:port           => '587',
# 			:authentication => "plain",
# 			:user_name      => ENV['SENDGRID_USERNAME'],
# 			:password       => ENV['SENDGRID_PASSWORD'],
# 			:domain         => 'travelercar-test.heroku.com',
# 			:enable_starttls_auto => true
# 	}