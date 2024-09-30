class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable  
  has_and_belongs_to_many :hotels
  has_many :bookings 
  has_many :rooms, through: :bookings
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable 

  validate :no_overlapping_bookings

private
       
def no_overlapping_bookings
  bookings.each do |booking|
    if booking.overlapping_bookings.exists?
         errors.add(:base, 'User cannot have overlapping bookings.')
    end
  end
end

end
