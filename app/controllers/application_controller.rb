class ApplicationController < ActionController::Base
  helper PricingHelper

  http_basic_authenticate_with :name => "tctc", :password => "tctc"

  protect_from_forgery

  before_filter :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end


  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def url_options
    {:locale => I18n.locale}.merge(super)
  end

  def authenticate_admin_user!
    redirect_to new_user_session_path unless current_user.has_role? :admin
  end

end
