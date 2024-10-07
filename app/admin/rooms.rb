ActiveAdmin.register Room do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :room_type, :features, :status, :hotel_id, :rate
  #
  # or
  #
  # permit_params do
  #   permitted = [:room_type, :features, :status, :hotel_id, :rate]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end 
  permit_params :room_type, :features, :status, :hotel_id, :rate

  index do
    selectable_column
    id_column
    column :room_type
    column :features
    column :status
    column :hotel
    column :rate
    column :created_at
    actions
  end  

  form do |f|
    f.inputs do
      f.input :room_type
      f.input :features
      f.input :status
      f.input :hotel, as: :select, collection: Hotel.all.map { |h| [h.name, h.id] } # Adjust this as needed
      f.input :rate
    end
    f.actions
  end
  


  
end
