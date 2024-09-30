class Hotel < ApplicationRecord  
  has_many :rooms 
  has_many :bookings, through: :rooms
  has_and_belongs_to_many :users
  validates :name, presence: true
  before_save :check_duplicate_record
  
  
  private
 
  def check_duplicate_record
    return unless Hotel.where(location: location, name: name).exists?
    errors.add(:base, "Hotel with location '#{location}' and name '#{name}' is already present.")
    throw(:abort) # Prevents the record from being saved
  end
  
end
