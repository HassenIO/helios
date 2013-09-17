class ApplicationController < ActionController::Base

	helper PricingHelper
	protect_from_forgery

	before_filter :set_locale

	rescue_from CanCan::AccessDenied do |exception|
		redirect_to root_path, :alert => exception.message
	end

	def set_locale
		I18n.locale = I18n.default_locale
		# I18n.locale = params[:locale] || I18n.default_locale
	end

	# Always add :locale parameter to URL
	def url_options
		{ :locale => I18n.locale }.merge super
	end

	def authenticate_admin_user!
		# If user not logged in or doesn't have admin role, make him back to login page
		if current_user.nil? || !current_user.has_role?(:admin)
			redirect_to new_user_session_path
		end
	end

	# Redirect after sign in
	def after_sign_in_path resource
		dashboards_path
	end

	# Convert Human datetime (dd/mm/YYYY - HH:MM) to system datetime format (YYYY-mm-dd HH:MM:SS)
	def human_to_system_datetime datetime
		return Time.strptime(datetime, "%d/%m/%Y %H:%M")
	end

	# If this is used as before_filter, redirect to sign in page without any flash message.
	def must_sign_in
		redirect_to( user_session_path ) if current_user.nil?
	end

end
