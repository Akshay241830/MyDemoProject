class BookingsController < ApplicationController
  # before_action :validity_params, only: :new
  # before_action :find_resource, only: %i[create new] 
  # before_action :authenticate_user!, only: :index
  def availability
    @hotel = Hotel.find(params[:hotel_id])

    # check_in = params[:check_in_date]
    # check_out = params[:check_out_date]
    # @available_rooms = @rooms.select do |room|
    #   room.bookings.none? do |booking|
    #     # Check for overlapping dates
    #     (booking.check_in_date < check_out) && (booking.check_out_date > check_in) && (booking.user_id == current_user.id)
    #   end
    # end
  end

  def check_availability
    # byebug
    @hotel = Hotel.find(params[:hotel_id])
    # @check_in = Date.parse(params[:check_in_date])
    # @check_out = Date.parse(params[:check_out_date])
    @check_in = params[:check_in_date]
    @check_out = params[:check_out_date]
    @rooms = @hotel.rooms

    if Date.parse(@check_in) < Date.today
      flash[:alert] = 'Check in cannot be in the past'
      redirect_to hotel_bookings_path(@hotel) and return
    elsif Date.parse(@check_out) < Date.today
      flash[:alert] = 'Check out cannot be in the past'
      redirect_to hotel_bookings_path(@hotel) and return
    end

    @available_rooms = @rooms.select do |room|
      room.bookings.where(
        '(check_in_date < ? AND check_out_date > ?) OR
         (check_in_date = ? AND check_out_date = ?) OR
         (check_in_date = ? OR check_out_date = ?)',
        Date.parse(@check_out),
        Date.parse(@check_in),
        Date.parse(@check_in),
        Date.parse(@check_out),
        Date.parse(@check_in),
        Date.parse(@check_out)
      ).empty?
    end

    session[:available_rooms] = @available_rooms.map(&:id)
    session[:check_in] = @check_in
    session[:check_out] = @check_out
    redirect_to new_hotel_booking_path(@hotel.id)
  end

  # def index
  #   @bookings = current_user.bookings.all
  # end

  def new
    @booking = Booking.new
    @hotel = Hotel.find(params[:hotel_id])
    # byebug
    if session[:available_rooms].present?
      @available_rooms = Room.where(id: session[:available_rooms])
      # @check_in = Date.parse(session[:check_in])
      # @check_out = Date.parse(session[:check_out])

      @check_in = session[:check_in]
      @check_out = session[:check_out]

      session.delete(:available_rooms)
      session.delete(:check_in)
      session.delete(:check_out)
    else
      @available_rooms = []
      @check_in = nil
      @check_out = nil
    end
  end

  def create
    # byebug

    ActiveRecord::Base.transaction do
      @booking = Booking.new(booking_params)
      @booking.user = current_user
      @total_days = if @booking.check_out_date == @booking.check_in_date
                      1
                    else
                      (@booking.check_out_date - @booking.check_in_date).to_i
                    end

      if @booking.save
        @room = Room.find(@booking.room_id)
        @total_price = @room.rate * @total_days

        @booking.update!(type_of_room: @room.room_type)
        @booking.update!(number_of_rooms: 1)
        @booking.update!(total_price: @total_price)

        # Redirect to create a payment session in PaymentsController
        # byebug
        redirect_to create_session_payments_path(booking_id: @booking.id)
      else
        flash.now[:alert] = 'There was an error creating your booking.'
        render :new, status: :unprocessable_entity
        # byebug
      end
    rescue ActiveRecord::RecordInvalid
      flash[:alert] = 'Booking could not be created.'
      render :new
    end
  end

  # def create
  #   ActiveRecord::Base.transaction do
  #     byebug
  #     @booking = Booking.new(booking_params)
  #     @booking.user = current_user
  #     @email = current_user.email
  #     @total_days = if @booking.check_out_date == @booking.check_in_date
  #                     1
  #                   else
  #                     (@booking.check_out_date - @booking.check_in_date).to_i
  #                   end

  #     byebug
  #     if @booking.save
  #       # byebug
  #       @room = Room.find(@booking.room_id)
  #       hotel = Hotel.find_by(id: @room.hotel_id)
  #       @total_price = @room.rate * @total_days
  #       byebug
  #       # current_user.hotels << hotel
  #       # @type = @room.room_type
  #       @booking.update!(type_of_room: @room.room_type)
  #       @booking.update!(number_of_rooms: 1)
  #       @booking.update!(total_price: @total_price)
  #       # @room.update!(status: "Booked")n
  #       # session.create
  #       # if session.pre
  #       MyBookingMailer.booking_email(@booking, @email).deliver_now
  #       redirect_to hotel_bookings_path, notice: 'Booking was successfully created.'
  #     else
  #       flash.now[:alert] = 'There was an error creating your booking.'
  #       render :new, status: :unprocessable_entity
  #     end
  #   rescue ActiveRecord::RecordInvalid
  #     byebug
  #     flash[:alert] = 'Booking could not be created.'
  #     render :new
  #   end
  # end

  def index
    # byebug 
    current_user = User.find(params[:user_id])
    @bookings = current_user.bookings
    # byebug
  end

  # def destroy
  #   # @hotel = Hotel.find(params[:hotel_id]) # Find the hotel by ID
  #   @booking = Booking.find(params[:id]) # Find the booking by ID
  #   @room = Room.find(@booking.room_id)
  #   @hotel = Hotel.find(@room.hotel_id)
  #   @booking.update!(status: 'Cancelled')

  #   redirect_to hotel_bookings_path(@hotel.id), notice: 'Booking was successfully canceled.'

  #   # byebug
  #   # @booking = current_user.bookings.find(params[:id])
  #   # @booking.update!(status: 'Cancelled')
  #   # redirect_to bookings_path, notice: 'Booking was successfully canceled.'
  # end

  def show
    # @hotel = Hotel.find(params[:hotel_id]) # Find the hotel by ID
    @booking = Booking.find(params[:id]) # Find the booking by ID
  end

  private

  def find_resource
    # @rooms = Rooms.where(params[:resource_id])
    @rooms = Room.where(hotel_id: params[:hotel_id])

    # byebug
    # if rooms .
  end

  def booking_params
    params.require(:booking).permit(:check_in_date, :check_out_date, :room_id).tap do |booking_params|
      if booking_params[:check_in_date].present?
        booking_params[:check_in_date] =
          Date.parse(booking_params[:check_in_date])
      end
      if booking_params[:check_out_date].present?
        booking_params[:check_out_date] =
          Date.parse(booking_params[:check_out_date])
      end
      booking_params[:room_id] = booking_params[:room_id].to_i if booking_params[:room_id].present?
    end
  end
end
