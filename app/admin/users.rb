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

  ActiveAdmin.register User do
    permit_params :email, :password, :password_confirmation, hotel_ids: []

    index do
      selectable_column
      id_column
      column :email
      column 'Hotels' do |user|
        user.hotels.map(&:name).join(', ')
      end
      actions
    end

    form do |f|
      f.inputs do
        f.input :email
        f.input :password
        f.input :password_confirmation
        f.input :hotels, as: :check_boxes
      end
      f.actions
    end
  end
end
