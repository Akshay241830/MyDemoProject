ActiveAdmin.register Booking do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :check_in_date, :check_out_date, :check_in_time, :check_out_time, :number_of_rooms, :type_of_room, :status, :user_id, :room_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:check_in_date, :check_out_date, :check_in_time, :check_out_time, :number_of_rooms, :type_of_room, :status, :user_id, :room_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  permit_params :check_in_date, :check_out_date, :check_in_time, :check_out_time, :number_of_rooms, :type_of_room, :status, :user_id, :room_id

  index do
    selectable_column
    id_column
    column :user
    column :room
    column :check_in_date
    column :check_out_date
    actions
  end

  form do |f|
    f.inputs do
      f.input :user
      f.input :room
      f.input :check_in_date
      f.input :check_out_date
      f.input :number_of_rooms
      f.input :type_of_room
      f.input :status
    end
    f.actions
  end




end
