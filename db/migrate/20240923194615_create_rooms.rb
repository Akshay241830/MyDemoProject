class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :room_type
      t.string :features
      t.string :status, default: "Available"
      t.references :hotel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
