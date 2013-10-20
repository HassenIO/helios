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

	# Convert Human datetime (dd/mm/YYYY - HH:MM) to system datetime format (YYYY-mm-dd HH:MM:SS)
	def human_to_system_datetime datetime
		return Time.strptime(datetime, "%d/%m/%Y %H:%M")
	end

	# If this is used as before_filter, redirect to sign in page without any flash message.
	def must_sign_in
		redirect_to( user_session_path ) if current_user.nil?
	end

	#
	# => Manage Devise redirections.
	#
	
	# Redirect after sign in
	def after_sign_in_path_for resource
		get_redirect_path dashboards_path
	end

	# Redirect after sign up
	def after_sign_up_path_for resource
		get_redirect_path dashboards_path
	end

	# Redirect after sign out
	def after_sign_out_path_for resource
		new_user_session_path
	end

	# The default redirection on signin/signup is different if the user tried to
	# perform a rent before being asked for a signin/signup
	def get_redirect_path path
		if session[:redirect_rent].blank?
			path
		else
			path = session[:redirect_rent]
			session[:redirect_rent] = nil
			path
		end
	end

end
