class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, ENV['STRIPE_WEBHOOK_SECRET']
      )
    rescue Stripe::SignatureVerificationError => e
      render json: { error: e.message }, status: :bad_request and return
    end

    case event['type']
    when 'checkout.session.completed'
      customer_id = event['data']['object']['customer']
      user = User.find_by(stripe_customer_id: customer_id)
      user&.update(subscribed: true)

    when 'customer.subscription.deleted', 'invoice.payment_failed'
      customer_id = event['data']['object']['customer']
      user = User.find_by(stripe_customer_id: customer_id)
      user&.update(subscribed: false)
    end

    render json: { message: 'success' }, status: :ok
  end
end