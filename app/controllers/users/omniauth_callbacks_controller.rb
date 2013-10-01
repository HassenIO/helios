class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def facebook

		# Get FB data.
		@auth = request.env["omniauth.auth"]

		# Get user info from our database, using FB user email.
		user = User.find_by_email @auth.info.email

		if user.blank?
			# The user isn't registred on our database -> sign up action.
			# Create the user on database using FB date.
			user = User.create(	first_name: @auth.info.first_name,
								last_name: @auth.info.last_name,
								provider: @auth.provider,
								uid: @auth.uid,
								email: @auth.info.email,
								birth_date: @auth.extra.raw_info.birthday,
								password: Devise.friendly_token[0, 20],
								confirmed_at: Time.now,
								confirmation_token: nil
								)
		else
			# The user was found on the database -> sign in action.
			# Update user info using FB data.
			user.first_name ||= @auth.info.first_name
			user.last_name ||= @auth.info.last_name
			user.uid ||= @auth.uid
			user.birth_date ||= @auth.extra.raw_info.birthday
			user.provider ||= @auth.provider
			user.uid ||= @auth.uid
			user.confirmed_at ||= Time.now
			user.confirmation_token ||= nil
			user.save

		end

		# In all cases (sign in or sign up), sign the user in and redirect him to his dashboard.
		sign_in user, :bypass => true
		redirect_to dashboards_path, notice: "Vous vous êtes correctement connecté via Facebook."

	end

end
