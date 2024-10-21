class MyBookingMailer < ApplicationMailer
  default from: 'yashubhadoria39@gmail.com' # Set your default sender email

  def booking_email(booking, email) 
    @booking = booking
    @room = Room.find(@booking.room_id)
    @email = email 
    # @room = Room.find(@booking.room_id)
    pdf = generate_pdf(@booking, @room)
    attachments["booking_details_#{@booking.id}.pdf"] = pdf
    # current_user = user 
    # new_email = email
    @booking = booking # Make user data accessible in the view
    # byebug
    mail(to: email, subject: 'New Booking Info ')
    # byebug # Set recipient and subject69  
  end 
 
  private

  # Method to generate PDF using Prawn
  def generate_pdf(booking, room)
    Prawn::Document.new do
      text "Booking Details", size: 24, style: :bold
      move_down 10

      text "Email: #{booking.user.email}"
      text "Check-in Date: #{booking.check_in_date}"
      text "Check-out Date: #{booking.check_out_date}"
      text "Number of Rooms: #{booking.number_of_rooms}"
      text "Room ID: #{room.id}"
      text "Type of Room: #{room.room_type}"
      text "Features: #{room.features}"
      text "Payment: #{room.rate}"
      text "Booking Status: #{booking.status}"

      move_down 20
      text "Thank you for booking with us!", style: :italic
    end.render # This renders the PDF as a binary string
  end

end
