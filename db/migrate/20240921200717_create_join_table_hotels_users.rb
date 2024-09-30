class CreateJoinTableHotelsUsers < ActiveRecord::Migration[7.0]
  def change
    create_join_table :hotels, :users do |t|
      t.index :hotel_id
      t.index :user_id
    end
  end
end
