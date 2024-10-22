class RoomsController < ApplicationController
    before_action :set_room, only: [:show, :edit, :update, :destroy]
  
    def index
      # @rooms =  
      # 
    end
  
    def show
    end
  
    def new
      @room = Room.new
    end
  
    def create
      @room = Room.new(room_params)
      if @room.save
        redirect_to @room, notice: 'Room was successfully created.'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @room.update(room_params)
        redirect_to @room, notice: 'Room was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @room.destroy
      redirect_to rooms_path, notice: 'Room was successfully deleted.'
    end
  
    private
  
    def set_room
      @room = Room.find(params[:id])
    end
  
    def room_params
      params.require(:room).permit(:room_type, :features, :rate) # Adjust attributes as necessary
    end
  
end
