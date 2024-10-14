class PaymentsController < ApplicationController
  def new
  end

  def create
    payment_method_id = params[:paymentMethodId]
    
    begin
      # Create a PaymentIntent
      payment_intent = Stripe::PaymentIntent.create({
        amount: 1000, # Amount in cents
        currency: 'usd',
        payment_method: payment_method_id,
        confirmation_method: 'automatic',
        confirm: true,
      })

      render json: { message: 'Payment successful!', payment_intent: payment_intent }
    rescue Stripe::CardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
