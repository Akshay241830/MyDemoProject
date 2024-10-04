class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_and_belongs_to_many :hotels
  has_many :bookings
  has_many :rooms, through: :bookings
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at email encrypted_password id remember_created_at reset_password_sent_at
       reset_password_token updated_at]
  end 


  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "location", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["rooms", "bookings"]  # Adjust based on your actual associations
  end

  # def self.ransackable_associations(_auth_object = nil)
  #   %w[bookings hotels rooms]
  # end

  # def self.ransackable_attributes(_auth_object = nil)
  #   %w[created_at id location name updated_at]
  # end

  # def self.ransackable_associations(auth_object = nil)
  #   ["bookings", "hotels", "rooms"]
  # end
  #   validate :no_overlapping_bookings

  # private

  # def no_overlapping_bookings
  #   bookings.each do |booking|
  #     if booking.overlapping_bookings.exists?
  #          errors.add(:base, 'User cannot have overlapping bookings.')
  #     end
  #   end
  # end
end
