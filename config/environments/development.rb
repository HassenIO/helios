helios::Application.configure do
	
	# Settings specified here will take precedence over those in config/application.rb

	# In the development environment your application's code is reloaded on
	# every request. This slows down response time but is perfect for development
	# since you don't have to restart the web server when you make code changes.
	config.cache_classes = false

	# Log error messages when you accidentally call methods on nil.
	config.whiny_nils = true

	# Show full error reports and disable caching
	config.consider_all_requests_local       = true
	config.action_controller.perform_caching = false

	# Don't care if the mailer can't send
	config.action_mailer.raise_delivery_errors = false

	# Print deprecation notices to the Rails logger
	config.active_support.deprecation = :log

	# Only use best-standards-support built into browsers
	config.action_dispatch.best_standards_support = :builtin

	# Raise exception on mass assignment protection for Active Record models
	config.active_record.mass_assignment_sanitizer = :strict

	# Log the query plan for queries taking more than this (works
	# with SQLite, MySQL, and PostgreSQL)
	config.active_record.auto_explain_threshold_in_seconds = 0.5

	# Do not compress assets
	config.assets.compress = true

	# Expands the lines which load the assets
	config.assets.debug = true

	# Define ActionMailer URL host
	config.action_mailer.default_url_options = { protocol: "http", host: "localhost", port: 3000, locale: I18n.locale }
	config.action_mailer.raise_delivery_errors = true
	config.action_mailer.delivery_method = :smtp

	# Use MailCatcher gem for locale emailing.
	config.action_mailer.smtp_settings = { address: "localhost", port: 1025 }

	# In case we don't want to test emails locally with MailCatcher gem,
	# here are production email settings
	# config.action_mailer.smtp_settings = {
	# 	:address        => "auth.smtp.1and1.fr",
	# 	:port           => "587",
	# 	:authentication => :plain,
	# 	:user_name      => ENV['1N1_USERNAME'],
	# 	:password       => ENV['1N1_PASSWORD']
	# }

	# Setting to enable SASS debug from Chrome
	config.assets.debug = true
	config.sass.debug_info = true
	config.sass.line_comments = false # source maps don't get output if this is true
	
end
