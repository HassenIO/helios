class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?

      if @user.sign_in_count == 0
        set_flash_message(:notice, :success_complete_profil, :kind => "Facebook") if is_navigational_format?
        sign_in @user
        redirect_to edit_user_registration_url
      else
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      end

    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def after_omniauth_failure_path_for(scope)
    new_user_session_path(scope)
  end

end
