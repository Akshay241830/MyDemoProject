class PaymentsController < ApplicationController
  def create_session
    # byebug
    @booking = Booking.find(params[:booking_id])  # Get the booking
    # byebug.+-
    @total_days = if @booking.check_out_date == @booking.check_in_date
                    1
                  else
                    (@booking.check_out_date - @booking.check_in_date).to_i
                  end

    @room = Room.find(@booking.room_id)
    @hotel = Hotel.find(@room.hotel_id)
    @total_price = @room.rate * @total_days * 100 # Stripe takes amounts in cents
    # Create Stripe Checkout Session
    @session = Stripe::Checkout::Session.create(
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
      success_url: "https://mysite-jtb3.onrender.com/payments/success/#{@booking.id}",
      cancel_url: 'https://mysite-jtb3.onrender.com/payments/cancel'
    )

    # Update the booking with session_id
    @booking.update!(session_id: @session.id)

    # # Redirect to Stripe's Checkout page
    # redirect_to session.url, allow_other_host: true
  end

  def success 
    # byebug

    @booking = Booking.find(params[:id])
    session_id = @booking.session_id
    # byebug

    # Retrieve the Stripe session
    session = Stripe::Checkout::Session.retrieve(session_id)

    payment_intent = Stripe::PaymentIntent.retrieve(session.payment_intent) 

    # @booking.update!()
    # byebug
    charge_id = payment_intent.latest_charge
    payment_intent_id = payment_intent.id
    # Retrieve the booking using session_id

    #  @booking = Booking.find_by(session_id: session_id)

    if @booking
      # Mark booking as paid
      @booking.update!(status: 'paid',payment_intent: payment_intent_id)
      

      # Send confirmation email
      MyBookingMailer.booking_email(@booking, @booking.user.email).deliver_now

      # byebug

      redirect_to booking_path(@booking.id), notice: 'Payment was successful and your booking was confirmed!'
    else
      redirect_to new_booking_path, alert: 'Booking not found.'
    end
  end

  def cancel
    flash[:alert] = 'Payment was canceled. No booking has been created.'
    redirect_to new_booking_path
  end
  
  def refund 
    # byebug 

    @booking = Booking.find(params[:id]) # Find the booking for which refund is to be made

    if @booking.payment_intent.present?
      # Issue the refund
      refund = Stripe::Refund.create({
        payment_intent: @booking.payment_intent,
      })

      # Update booking status to refunded or canceled
      @booking.update!(status: 'refunded')

      flash[:notice] = "Refund has been processed successfully." 
      MyBookingMailer.booking_email(@booking, @booking.user.email).deliver_now
      # redirect_to bookings_path
      redirect_to booking_path(@booking.id)
    else
      flash[:alert] = "Unable to process the refund."
      redirect_to bookings_path
    end 

  end




end
