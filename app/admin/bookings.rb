ActiveAdmin.register Booking do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :check_in_date, :check_out_date, :check_in_time, :check_out_time, :number_of_rooms, :type_of_room, :status, :user_id, :room_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:check_in_date, :check_out_date, :check_in_time, :check_out_time, :number_of_rooms, :type_of_room, :status, :user_id, :room_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
