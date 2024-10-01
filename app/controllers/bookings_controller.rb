class BookingsController < ApplicationController 
    before_action :find_resource, only: [:new, :create]
    # before_action :find_resource, only: :create
  
    def new
      # @booking = @rooms.bookings.new 
      # @rooms = Room.where(hotel_id: params[:hotel_id])  
      @booking = Booking.new
        
    end 
     
    def index
      @bookings = Booking.all
    end
  
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
      # ActiveRecord::Base.transaction do
        @booking = Booking.new(booking_params)
        @booking.user = current_user 
          
        if @booking.save 
          byebug
          @room = Room.find(@booking.room_id)   
          @type = @room.room_type
          @booking.update!(type_of_room:@room.room_type) 
          @booking.number_of_rooms = 1
          # @room.update!(status: "Booked")  # This will raise an error if it fails
         
          redirect_to @booking
        else
          render :new
        end
      # rescue ActiveRecord::RecordInvalid
        # render :new, alert: 'Booking could not be created.'
      # end
    end
    
  
    def destroy
      @booking = current_user.bookings.find(params[:id])
      @booking.destroy
      redirect_to bookings_path, notice: 'Booking was successfully canceled.'
    end
    
     def show
     end
    private
  
    def find_resource
      # @rooms = Rooms.where(params[:resource_id])
      @rooms = Room.where(hotel_id: params[:hotel_id])
    end
  
    def booking_params
      # byebug
      params.require(:booking).permit(:check_in_date, :check_out_date, :check_in_time, :check_out_time, :number_of_rooms, :room_id)
      
    end
  
end
