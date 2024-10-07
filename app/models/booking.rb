class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :check_in_date, :check_out_date, :check_in_time, :check_out_time, presence: true

  validate :check_if_date_is_old
  validate :check_if_dates_are_valid 
  validate :check_for_overlapping_bookings

  def self.ransackable_associations(auth_object = nil)
    ["room", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["check_in_date", "check_in_time", "check_out_date", "check_out_time", "created_at", "id", "number_of_rooms", "room_id", "status", "type_of_room", "updated_at", "user_id"]
  end


  private

  def check_if_dates_are_valid
    return unless check_out_date < check_in_date

    errors.add(:check_out_date, 'must be after the check-in date.')
  end

  def check_if_date_is_old
    if check_in_date < Date.today
      errors.add(:check_in_date, 'checkin cannot be in the past.')
    elsif check_out_date < Date.today
      errors.add(:check_out_date, 'checkout cannot be in the past.')
    end
  end

  def check_for_overlapping_bookings
    return if check_in_date.nil? || check_out_date.nil? || room_id.nil?

    overlapping_bookings = Booking.where(room_id: room_id)
                                  .where.not(id: id) # Exclude the current booking if updating
                                  .where('check_in_date < ? AND check_out_date > ?', check_out_date, check_in_date)
                                  .or(Booking.where(room_id: room_id)
                                              .where.not(id: id)
                                              .where('check_in_date = ? AND check_out_date = ?', check_in_date, check_out_date))

    return unless overlapping_bookings.exists?

    errors.add(:base, 'The selected date range overlaps with an existing booking.')
  end
end
