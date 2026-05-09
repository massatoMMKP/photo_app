class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  

  def after_inactive_sign_up_path_for(resource)
    # Passamos o token único na URL de forma segura (sem expor IDs ou e-mails)
    check_email_path(token: resource.confirmation_token)
  end

end
