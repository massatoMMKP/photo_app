class WelcomeController < ApplicationController
  before_action :authenticate_user!, except: [ :check_email, :verify_confirmation ]
  def index
  end

  def check_email
  end

  def verify_confirmation
    # CENÁRIO 1: Ele confirmou na outra aba do navegador.
    # O cookie atualizou e ele já está logado "sem saber"!
    if user_signed_in?
      redirect_to root_path, notice: "Sua conta já foi confirmada! Bem-vindo(a)."
      return # O "return" faz o código parar aqui e não executar o resto
    end

    # CENÁRIO 2: Ele confirmou no celular.
    # A aba do PC não atualizou o cookie, então a sessão antiga ainda está lá.
    user = User.find_by(email: session[:unconfirmed_email])

    if user && user.confirmed?
      sign_in(user) # Logamos ele no PC agora!
      session.delete(:unconfirmed_email)
      redirect_to root_path, notice: "Conta confirmada com sucesso! Bem-vindo(a)."
    else
      # CENÁRIO 3: Ele é impaciente e clicou no botão sem confirmar no e-mail.
      redirect_to check_email_path, alert: "Você ainda não confirmou o e-mail. Verifique sua caixa de entrada e spam."
    end
  end
end
