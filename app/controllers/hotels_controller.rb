class HotelsController < ApplicationController 
  # skip_before_action :verify_authenticity_token 
  def search 
     @hotels = Hotel.where(location: params[:location])
  end 

  def show 
    @hotel = Hotel.find_by(id: params[:id])
     @no_of_rooms = @hotel.rooms.count 

     @no_of_non_ac_rooms = @hotel.rooms.where(room_type: "Non AC",status: "Available").count
     @no_of_ac_rooms = @hotel.rooms.where(room_type: "AC",status: "Available").count
     
  end

end
