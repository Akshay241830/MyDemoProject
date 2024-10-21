class Hotel < ApplicationRecord  
  has_many :rooms 
  has_many :bookings, through: :rooms
  has_and_belongs_to_many :users
  validates :name, presence: true 
  validates :name, uniqueness: { scope: :location, message: "A hotel with this name and location already exists." }

  # before_save :check_duplicate_record

  def self.ransackable_associations(auth_object = nil)
    ["bookings", "rooms", "users"]
  end
  
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "location", "name", "updated_at"]
  end
  
  
  # private
 
  # def check_duplicate_record 
  #   # byebug
  #   # return unless Hotel.where(location: location, name: name).exists?
  #   # errors.add(:base, "Hotel with location '#{location}' and name '#{name}' is already present.")
  #   # throw(:abort) # Prevents the record from being saved 
  #   if name.exists? && location.exists 
  #   errors.add(:base, "Hotel with location '#{location}' and name '#{name}' is already present.")
  #   throw(:abort) # Prevents the record from being saved       
  #   end
  # end
  
end
