# config/routes.rb
Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: "users/confirmations",
    registrations: "users/registrations"
  }

  # Rotas do fluxo de confirmação — agora dentro do namespace correto
  get "users/confirmation/check_email", 
      to: "users/confirmations#check_email",
      as: :check_email

  get "users/confirmation/verify", 
      to: "users/confirmations#verify_confirmation",
      as: :verify_confirmation

  root "welcome#index"
end