ActiveAdmin.register User do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # Add filters for associated hotels
  # filter :hotels, as: :select, collection: -> { Hotel.all.pluck(:name, :id) }

  # # Define the index view to display associated hotels
  # filter :hotels, as: :select, collection: -> { Hotel.all.pluck(:name, :id) }

  # index do
  #   selectable_column
  #   id_column
  #   column :email # or any other user attributes
  #   column "Hotels" do |user|
  #     user.hotels.map(&:name).join(", ") # Display hotel names
  #   end
  #   actions
  # end

  # form do |f|
  #   f.inputs do
  #     f.input :email # or other user attributes
  #     f.input :hotels, as: :check_boxes # Allows selection of hotels
  #   end
  #   f.actions
  # end
  # filter :hotels, as: :select, collection: -> { Hotel.all.pluck(:name, :id) }, input_html: { multiple: true }

  # # Add a custom Ransack predicate
  # controller do
  #   def scoped_collection
  #     super.includes(:hotels)
  #   end
  # end 


  # filter :hotel_id, as: :select, collection: -> { Hotel.all.pluck(:name, :id) }, input_html: { multiple: true }

  # index do
  #   selectable_column
  #   id_column
  #   column :email
  #   column "Hotels" do |user|
  #     user.hotels.map(&:name).join(", ")
  #   end
  #   actions
  # end

  # form do |f|
  #   f.inputs do
  #     f.input :email
  #     f.input :hotels, as: :check_boxes
  #   end
  #   f.actions
  # end
  # filter :hotels, as: :select, collection: -> { Hotel.all.pluck(:name, :id) }, input_html: { multiple: true }

  # controller do
  #   # Override the index action to include the custom scope
  #   def scoped_collection
  #     super.includes(:hotels)
  #   end

  #   # Define a custom search for hotels
  #   def index
  #     super do |format|
  #       if params[:q] && params[:q][:hotels_id_in]
  #         hotel_ids = params[:q][:hotels_id_in].reject(&:blank?)
  #         @users = User.with_hotel_ids(hotel_ids)
  #       end
  #     end
  #   end
  # end

  # index do
  #   selectable_column
  #   id_column
  #   column :email
  #   column "Hotels" do |user|
  #     user.hotels.map(&:name).join(", ")
  #   end
  #   actions
  # end

  # form do |f|
  #   f.inputs do
  #     f.input :email
  #     f.input :hotels, as: :check_boxes
  #   end
  #   f.actions
  # end


  # permit_params :email, :encrypted_password, hotel_ids: []

  # index do
  #   selectable_column
  #   id_column
  #   column :email
  #   column :hotels do |user|
  #     user.hotels.map(&:name).join(", ")
  #   end
  #   actions
  # end

  # filter :email
  # filter :hotels, as: :select, collection: -> { Hotel.all }

  # form do |f|
  #   f.inputs do
  #     f.input :email
  #     f.input :hotels, as: :check_boxes, collection: Hotel.all
  #   end
  #   f.actions
  # end 



  permit_params :email, :encrypted_password, hotel_ids: []

  index do
    selectable_column
    id_column
    column :email
    column :hotels do |user|
      user.hotels.map(&:name).join(", ")
    end
    actions
  end

  # Explicitly define filters
  filter :email
  filter :hotels, as: :select, collection: -> { Hotel.all }

  form do |f|
    f.inputs do
      f.input :email
      f.input :hotels, as: :check_boxes, collection: Hotel.all
    end
    f.actions
  end



end
