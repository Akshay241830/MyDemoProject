class BookingsController < ApplicationController
  # before_action :validity_params, only: :new
  before_action :find_resource, only: %i[create new]
  def availability
    # @rooms
    # @hotel
    check_in = Date.parse(params[:booking][:check_in_date])
    check_out = Date.parse(params[:booking][:check_out_date])
    @hotel = Hotel.find_by(id: params[:booking][:hotel_id])

    @rooms = @hotel.rooms

    byebug 

    if check_in < Date.today 
      flash[:alert] = 'Check in cannot be in past'
    elsif check_out < Date.today   
      flash[:alert] = 'Check out cannot be in past'
    else  
       
      @available_rooms = @rooms.select do |room|
        room.bookings.none? do |booking|
          # Check for overlapping dates
          (booking.check_in_date < check_out) && (booking.check_out_date > check_in) && (booking.user_id == current_user.id)
        end
      end 
      

    end
  end

  def new
    @booking = Booking.new

    @myroom = @rooms
    # @hotel = Hotel.find(params[:hotel_id]) # Ensure you fetch the hotel
    # @rooms = @hotel.rooms.all

    # # Fetch check_in and check_out from params, default to nil if not present
    # check_in = params[:check_in_date]
    # check_out = params[:check_out_date]

    # @available_rooms = @rooms.select do |room|
    #   room.bookings.none? do |booking|
    #     # Check for overlapping dates
    #     (booking.check_in_date < check_out) &&
    #     (booking.check_out_date > check_in) &&
    #     (booking.user_id == current_user.id)
    #   end
    # end
  end

  def index
    @bookings = current_user.bookings.all
  end

  def create
    ActiveRecord::Base.transaction do
      @booking = Booking.new(booking_params)
      @booking.user = current_user

      if @booking.save
        # byebug
        @room = Room.find(@booking.room_id)
        hotel = Hotel.find_by(id: @room.hotel_id)
        @booking.update!(number_of_rooms: 1)
        # current_user.hotels << hotel
        # @type = @room.room_type
        @booking.update!(type_of_room: @room.room_type)
        @booking.number_of_rooms = 1
        # @room.update!(status: "Booked")  # This will raise an error if it fails

        redirect_to bookings_path, notice: 'Booking was successfully created.'
      else
        flash.now[:alert] = 'There was an error creating your booking.'
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid
      # byebug
      flash[:alert] = 'Booking could not be created.'
      render :new
    end
  end

  def destroy
    # byebug
    @booking = current_user.bookings.find(params[:id])
    @booking.update!(status: 'Cancelled')
    redirect_to bookings_path, notice: 'Booking was successfully canceled.'
  end

  def show
    @booking = current_user.bookings.find(params[:id])
  end

  private

  def find_resource
    # @rooms = Rooms.where(params[:resource_id])
    @rooms = Room.where(hotel_id: params[:hotel_id])
    @hotel = Hotel.find_by(id: params[:hotel_id])
    byebug
  end

  # def booking_params
  #   # byebug
  #   params.require(:booking).permit(:check_in_date, :check_out_date, :check_in_time, :check_out_time, :room_id)
  # end

  def validity_params
    params.require(:room).permit(:check_in_date, :check_out_date)
  end
end

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
