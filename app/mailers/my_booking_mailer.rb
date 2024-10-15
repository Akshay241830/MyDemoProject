class MyBookingMailer < ApplicationMailer
  default from: 'yashubhadoria39@gmail.com' # Set your default sender email

  def booking_email(booking, email)
    @email = email
    # current_user = user 
    # new_email = email
    @booking = booking # Make user data accessible in the view
    byebug
    mail(to: email, subject: 'New Booking Info ')
    byebug # Set recipient and subject
  end
end
