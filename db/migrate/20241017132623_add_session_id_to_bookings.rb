class AddSessionIdToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :session_id, :string
  end
end
