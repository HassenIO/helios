class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

	before_filter :check_email_from_fb, only: [:facebook, :facebook_signup_tc]

	def facebook

		if @user.blank?
			redirect_to new_user_session_path, alert: "Vous devez d'abord vous inscrire sur TravelerCar pour pouvoir y accéder via Facebook."
		else
			sign_in @user
			redirect_to dashboards_path, notice: "Vous vous êtes correctement connecté via Facebook."
		end

	end

	def facebook_signup_tc
		
		if @user.blank?
		else
			redirect_to new_user_session_path, alert: "Vous êtes déjà inscrit sur TravelerCar."
		end

	end



	private

	def check_email_from_fb
		@user = User.find_by_email request.env["omniauth.auth"].info.email
	end

	# def facebook
	# 		# You need to implement the method below in your model (e.g. app/models/user.rb)
	# 		@user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

	# 		if @user.persisted?

	# 			if @user.sign_in_count == 0
	# 				set_flash_message(:notice, :success_complete_profil, :kind => "Facebook") if is_navigational_format?
	# 				sign_in @user
	# 				redirect_to edit_user_registration_url
	# 			else
	# 				set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
	# 				sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
	# 			end

	# 		else
				
	# 			session["devise.facebook_data"] = request.env["omniauth.auth"]
	# 			flash[:alert] = @user.errors.full_messages.join(",")
	# 			redirect_to new_user_registration_url

	# 		end
	# 	end

end
