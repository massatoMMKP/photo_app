class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!

  protected

  def after_inactive_sign_up_path_for(resource)
    session[:unconfirmed_email] = resource.email
    check_email_path
  end
end
