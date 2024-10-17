class PaymentsController < ApplicationController
  def create_session
    byebug
    @booking = Booking.find(params[:booking_id])  # Get the booking
    byebug
    @total_days = if @booking.check_out_date == @booking.check_in_date
                    1
                  else
                    (@booking.check_out_date - @booking.check_in_date).to_i
                  end

    @room = Room.find(@booking.room_id)
    @hotel = Hotel.find(@room.hotel_id)
    @total_price = @room.rate * @total_days * 100 # Stripe takes amounts in cents
    # Create Stripe Checkout Session
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: {
            name: @hotel.name
          },
          unit_amount: @total_price.to_i
        },
        quantity: 1
      }],
      mode: 'payment',
      success_url: 'https://www.example.com',
      cancel_url: 'https://www.example.com'
    )

    # Update the booking with session_id
    @booking.update!(session_id: session.id)

    # Redirect to Stripe's Checkout page
    redirect_to session.url, allow_other_host: true
  end

  def success
    session_id = params[:session_id]
    byebug

    # Retrieve the Stripe session
    session = Stripe::Checkout::Session.retrieve(session_id)

    payment_intent = Stripe::PaymentIntent.retrieve(session.payment_intent)

    charge_id = payment_intent.charges.data[0].id

    # Retrieve the booking using session_id
    @booking = Booking.find_by(session_id: session_id)

    if @booking
      # Mark booking as paid
      @booking.update!(status: 'paid')

      # Send confirmation email
      MyBookingMailer.booking_email(@booking, @booking.user.email).deliver_now

      byebug

      redirect_to hotel_bookings_path, notice: 'Payment was successful and your booking was confirmed!'
    else
      redirect_to new_booking_path, alert: 'Booking not found.'
    end
  end

  def cancel
    flash[:alert] = 'Payment was canceled. No booking has been created.'
    redirect_to new_booking_path
  end
end
