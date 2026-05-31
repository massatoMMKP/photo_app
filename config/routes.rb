# config/routes.rb
Rails.application.routes.draw do
  resources :photos, only: [:index, :new, :create]
  get "webhooks/stripe"
  get "payments/new"
  get "payments/create"
  get "payments/success"
  get "payments/cancel"
  devise_for :users, controllers: {
    confirmations: "users/confirmations",
    registrations: "users/registrations"
  }

  # Rotas do fluxo de confirmação — agora dentro do namespace correto
  devise_scope :user do
    get "users/confirmation/check_email",
        to: "users/confirmations#check_email",
        as: :check_email

    get "users/confirmation/verify",
        to: "users/confirmations#verify_confirmation",
        as: :verify_confirmation
  end

  root "welcome#index"
  post '/webhooks/stripe', to: 'webhooks#stripe'

  resources :payments, only: [:new, :create] do
  collection do
    get :success
    get :cancel
  end
end
end
