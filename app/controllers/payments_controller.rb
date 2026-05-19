class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    # Cria o cliente no Stripe se ainda não existe
    if current_user.stripe_customer_id.nil?
      customer = Stripe::Customer.create(email: current_user.email)
      current_user.update(stripe_customer_id: customer.id)
    end

    # Pega o plano escolhido pelo usuário
    price_id = params[:plan] == 'amaze' ? ENV['STRIPE_AMAZE_PRICE_ID'] : ENV['STRIPE_PREMIUM_PRICE_ID']

    # Cria a Checkout Session para assinatura
    session = Stripe::Checkout::Session.create(
      customer: current_user.stripe_customer_id,
      payment_method_types: ['card'],
      mode: 'subscription',
      line_items: [{
        price: price_id,
        quantity: 1
      }],
      success_url: payments_success_url,
      cancel_url: payments_cancel_url
    )

    redirect_to session.url, allow_other_host: true
  end

  def success
  end

  def cancel
  end
end