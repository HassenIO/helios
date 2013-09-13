class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def facebook

		# Get callback action from facebook params. Default to login.
		action = request.env["omniauth.params"]["tc_action"] || "login"
		@auth = request.env["omniauth.auth"]

		if action == "login"
			facebook_login
		elsif action == "signup"
			facebook_signup
		else
			redirect_to_login "Vous devriez nous contacter pour une embauche ;)"
		end

	end



	private

	# This method handle TC login from Facebook
	def facebook_login
		user = User.find_by_email request.env["omniauth.auth"].info.email

		if user.blank?
			redirect_to_login "Vous devez d'abord vous inscrire sur TravelerCar pour pouvoir y accéder via Facebook."
		else
			# Update user info using FB data
			user.birth_date ||= @auth.extra.raw_info.birthday
			user.first_name ||= @auth.info.first_name
			user.last_name ||= @auth.info.last_name
			user.provider ||= @auth.provider
			user.uid ||= @auth.uid
			user.save

			login_user user
		end
	end

	# This method handle TC signup from facebook
	def facebook_signup
		
		# Is the invitation code valid?
		code = request.env["omniauth.params"]["invitation_code"]
		if code && Invitation.get_invitation( code )

			# Test user existance
			user = User.find_by_email request.env["omniauth.auth"].info.email

			if user.blank?
				# Create new user on database
				user = User.create(	first_name: @auth.info.first_name,
									last_name: @auth.info.last_name,
									provider: @auth.provider,
									uid: @auth.uid,
									birth_date: @auth.extra.raw_info.birthday,
									email: @auth.info.email,
									password: Devise.friendly_token[0, 20]
									)
			end
			login_user user
			
		else
			redirect_to_login "Veuillez entrer un code invitation valide."
		end

	end

	# This method just redirect to login page with a specific alert message
	def redirect_to_login msg
		redirect_to new_user_session_path, alert: msg
	end

	# Login the user
	def login_user user
		sign_in user
		redirect_to dashboards_path, notice: "Vous vous êtes correctement connecté via Facebook."
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
