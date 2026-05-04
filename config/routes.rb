Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: "users/confirmations",
    registrations: "users/registrations",
  }

  get "check_email", to: "welcome#check_email"
  get 'verify_confirmation', to: 'welcome#verify_confirmation'

  

  root "welcome#index"
end
