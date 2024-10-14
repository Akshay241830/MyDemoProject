ActiveAdmin.register Hotel do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :location
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :location]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end 

  permit_params :name, :location

  index do
    selectable_column
    id_column
    column :name
    column :location
    column :users do |hotel|
      hotel.users.map(&:email).join(", ")
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :location
      f.input :users, as: :check_boxes, collection: User.all
    end
    f.actions
  end
  
end
