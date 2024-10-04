class BookingsController < ApplicationController
  before_action :find_resource, only: %i[new create]
  # before_action :find_resource, only: :create

  def new
    # @booking = @rooms.bookings.new
    # @rooms = Room.where(hotel_id: params[:hotel_id])
    @booking = Booking.new
  end

  def index
    @bookings = current_user.bookings.all
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

  def create
    ActiveRecord::Base.transaction do
      @booking = Booking.new(booking_params)
      @booking.user = current_user

      if @booking.save
        # byebug
        @room = Room.find(@booking.room_id)
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
      byebug
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
    # byebug
    # if rooms .
  end

  def booking_params
    # byebug
    params.require(:booking).permit(:check_in_date, :check_out_date, :check_in_time, :check_out_time,
                                    :number_of_rooms, :room_id)
  end
end
