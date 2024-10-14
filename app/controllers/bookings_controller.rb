class BookingsController < ApplicationController
  # before_action :find_resource, only: %i[new create]
  # before_action :find_resource, only: :create
  def availability
    @hotel = Hotel.find(params[:hotel_id])
  end

  # def check_availability 
  #   byebug
  #   @hotel = Hotel.find(params[:hotel_id])

  #   @check_in = Date.parse(params[:check_in_date])

  #   @check_out = Date.parse(params[:check_out_date])

  #   @rooms = @hotel.rooms

  #   if @check_in < Date.today
  #     flash[:alert] = 'Check in cannot be in past'
  #   elsif @check_out < Date.today
  #     flash[:alert] = 'Check out cannot be in past'
  #   else

  #     # @available_rooms = @rooms.select do |room|
  #     #   room.bookings.where("tsrange(check_in_date, check_out_date, '[]') && tsrange(?, ?, '[]')", check_in, check_out).empty?
  #     # end
  #     @available_rooms = @rooms.select do |room|
  #       room.bookings.where('(check_in_date < ? AND check_out_date > ?) OR (check_in_date = ? AND check_out_date = ?)',
  #                           @check_out, @check_in, @check_in, @check_out).empty?
  #     end
  #     # byebug
  #     # render :availability, locals: { available_rooms: @available_rooms }
  #     render 'bookings/check_availability'
  #     # render 'bookings/custom_availability_view'
  #   end
  # end 

  def check_availability  
    byebug
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
      room.bookings.where('(check_in_date < ? AND check_out_date > ?) OR (check_in_date = ? AND check_out_date = ?)',
                          Date.parse(@check_out), Date.parse(@check_in), Date.parse(@check_in), Date.parse(@check_out)).empty?
    end
  
    # Store available room IDs and check-in/check-out dates in session
    session[:available_rooms] = @available_rooms.map(&:id)
    session[:check_in] = @check_in
    session[:check_out] = @check_out
  
    # Redirect to new booking action
    redirect_to new_hotel_booking_path(@hotel.id)
  end
  
  
  def new 
    @booking = Booking.new
    @hotel = Hotel.find(params[:hotel_id]) 
    byebug
    if session[:available_rooms].present?
      @available_rooms = Room.where(id: session[:available_rooms])
      # @check_in = Date.parse(session[:check_in])
      # @check_out = Date.parse(session[:check_out])  

      @check_in = session[:check_in] 
      @check_out = session[:check_out]  
  
      # Clear the session after use
      session.delete(:available_rooms)
      session.delete(:check_in)
      session.delete(:check_out)
    else
      @available_rooms = [] # No available rooms found
      @check_in = nil
      @check_out = nil
    end
  end
  

  # def new 
  #   byebug
  #   @booking = Booking.new
  #   # @rooms = Room.all # Fetch all rooms initially
  # end
  

 

  # def edit
  #   @booking = current_user.bookings.find(params[:id])
  #   room = Room.find_by!(id: @booking.room_id)
  #   check_in_date = .check_in_date
  #   check_out_date = @booking.check_out_date

  #    hotel_id = Room.find_by!(id:@booking.room_id).hotel_id
  #    hotel = Hotel.find_by!(id:hotel_id)
  #    @rooms = hotel.rooms

  #   if @booking.update(booking_params)
  #     redirect_to bookings_path, notice: 'Booking was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

  # def update
  #   # @booking = current_user.bookings.find(params[:id])
  #   if
  #   if @booking.update(booking_params)
  #     redirect_to bookings_path, notice: 'Booking was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

  # def create
  #   @booking = Booking.new(booking_params)
  #   @booking.user = current_user

  #   if @booking.save
  #     @room = Room.where(room_id: room_id)
  #     @room.status = "Booked"
  #     redirect_to @booking, notice: 'Booking was successfully created.'
  #   else
  #     render :new
  #   end
  # end

  def create
    ActiveRecord::Base.transaction do 
      byebug
      @booking = Booking.new(booking_params)
      @booking.user = current_user 

      
    byebug
      if @booking.save
        # byebug
        @room = Room.find(@booking.room_id) 
        hotel = Hotel.find_by(id:@room.hotel_id)
        # current_user.hotels << hotel
        # @type = @room.room_type
        @booking.update!(type_of_room: @room.room_type)
        @booking.update!(number_of_rooms: 1)
        # @room.update!(status: "Booked") 

        redirect_to hotel_bookings_path, notice: 'Booking was successfully created.'
      else
        flash.now[:alert] = 'There was an error creating your booking.'
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid
      byebug
      flash[:alert] = 'Booking could not be created.'
      render :new
    end
  end 

  def index
    @bookings = current_user.bookings.all
    byebug
  end

  def destroy  

    @hotel = Hotel.find(params[:hotel_id]) # Find the hotel by ID
    @booking = current_user.bookings.find(params[:id]) # Find the booking by ID
    @booking.update!(status: 'Cancelled')
  
    redirect_to hotel_bookings_path(@hotel), notice: 'Booking was successfully canceled.'

    # byebug
    # @booking = current_user.bookings.find(params[:id])
    # @booking.update!(status: 'Cancelled')
    # redirect_to bookings_path, notice: 'Booking was successfully canceled.'
  end 

def show
  @hotel = Hotel.find(params[:hotel_id]) # Find the hotel by ID
  @booking = current_user.bookings.find(params[:id]) # Find the booking by ID
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
      booking_params[:check_in_date] = Date.parse(booking_params[:check_in_date]) if booking_params[:check_in_date].present?
      booking_params[:check_out_date] = Date.parse(booking_params[:check_out_date]) if booking_params[:check_out_date].present?
      booking_params[:room_id] = booking_params[:room_id].to_i if booking_params[:room_id].present?
    end
  end

  # def booking_params
  #   # byebug
  #   params.require(:booking).permit(:check_in_date, :check_out_date, :room_id) 
  #   byebug
  # end
end
