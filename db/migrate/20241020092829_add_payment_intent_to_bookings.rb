class AddPaymentIntentToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :payment_intent, :string
  end
end
