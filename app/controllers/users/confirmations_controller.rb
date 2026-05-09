# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController

  def show
    super do |resource|
      if resource.errors.empty?
        sign_in(resource)
        redirect_to root_path, notice: "Email confirmado com sucesso!" and return
      end
    end
  end

  def verify_confirmation
    # CENÁRIO 1: Confirmou na outra aba — cookie já atualizou
    if user_signed_in?
      redirect_to root_path, notice: "Sua conta já foi confirmada! Bem-vindo(a)."
      return
    end

    # CENÁRIO 2: Confirmou no celular — busca no banco pelo email da sessão
    user = User.find_by(email: session[:unconfirmed_email])

    if user&.confirmed?
      sign_in(user)
      session.delete(:unconfirmed_email)
      redirect_to root_path, notice: "Conta confirmada com sucesso! Bem-vindo(a)."
    else
      # CENÁRIO 3: Ainda não confirmou
      redirect_to check_email_users_confirmation_path,
                  alert: "Você ainda não confirmou o e-mail. Verifique sua caixa de entrada e spam."
    end
  end

  protected

  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource) # Auto-login after confirmation
    root_path
  end


  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
