class Room < ApplicationRecord
  belongs_to :hotel
  has_many :bookings
  has_many :users, through: :bookings
  validates :room_type, :status, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "features", "hotel_id", "id", "rate", "room_type", "status", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["bookings", "hotel", "users"]
  end
end
