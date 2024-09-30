class AddRateToRoom < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :rate, :integer
  end
end
