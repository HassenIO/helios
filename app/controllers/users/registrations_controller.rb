class Users::RegistrationsController < Devise::RegistrationsController

	before_filter :standardise_birthdate, only: [:update]

	# Signup page
	def new
	end

	# PUT /resource
	# We need to use a copy of the resource because we don't want to change
	# the current user in place.
	def update
		self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
		prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

		successfully_updated =	if self.resource.provider.blank?
									resource.update_with_password(resource_params)
								else
									resource.update_without_password(resource_params)
								end

		if successfully_updated
			if is_navigational_format?
				flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
						:update_needs_confirmation : :updated
				set_flash_message :notice, flash_key
			end
			sign_in resource_name, resource, :bypass => true
			respond_with resource, :location => after_update_path
		else
			clean_up_passwords resource
			respond_with resource
		end
	end

	def after_update_path
		edit_user_registration_path
	end

private

	def standardise_birthdate
		birth_date = params[:user][:birth_date]
		params[:user][:birth_date] = ( /\A\d{1,2}\/\d{1,2}\/\d{4}\z/.match(birth_date) ) ? Time.strptime(birth_date, "%d/%m/%Y") + 1.day : nil
	end

end
