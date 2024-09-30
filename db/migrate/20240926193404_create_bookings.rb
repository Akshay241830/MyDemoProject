class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.date :check_in_date
      t.date :check_out_date
      t.time :check_in_time
      t.time :check_out_time
      t.integer :number_of_rooms
      t.string :type_of_room
      t.string :status
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
