class Users::RegistrationsController < Devise::RegistrationsController

  # Signup page
  # Change from default to add the invitation code gate.
  def new
    invitation = Invitation.get_invitation params[:code]

    if invitation.nil?
      redirect_to new_user_session_path, alert: "Le code invitation #{params[:code]} est invalide."
    else
      flash.now[:notice] = "Bienvenue #{invitation.desc}. Nous sommes impatient de vous compter parmis nos membres."
    end
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    successfully_updated = if self.resource.provider.blank?
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
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

end
