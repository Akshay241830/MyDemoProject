require 'rails_helper'

RSpec.describe Booking, type: :model do
  let(:hotel) { Hotel.create!(name: 'Test Hotel', location: 'Test City') }
  let(:room) { Room.create!(room_type: 'Deluxe', status: 'Available', rate: 100, hotel: hotel) }
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let(:booking) { Booking.new(user: user, room: room, check_in_date: Date.today + 1, check_out_date: Date.today + 2) }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(booking).to be_valid
    end

    it 'is not valid without a check_in_date' do
      booking.check_in_date = nil
      expect(booking).not_to be_valid
      expect(booking.errors[:check_in_date]).to include("can't be blank")
    end

    it 'is not valid without a check_out_date' do
      booking.check_out_date = nil
      expect(booking).not_to be_valid
      expect(booking.errors[:check_out_date]).to include("can't be blank")
    end

    it 'is not valid if check-out date is before check-in date' do
      booking.check_out_date = booking.check_in_date - 1
      expect(booking).not_to be_valid
      expect(booking.errors[:check_out_date]).to include('must be after the check-in date.')
    end

    it 'is not valid if check-in date is in the past' do
      booking.check_in_date = Date.yesterday
      expect(booking).not_to be_valid
      expect(booking.errors[:check_in_date]).to include('checkin cannot be in the past.')
    end

    it 'is not valid if check-out date is in the past' do
      booking.check_out_date = Date.yesterday
      expect(booking).not_to be_valid
      expect(booking.errors[:check_out_date]).to include('checkout cannot be in the past.')
    end
  end

  context 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to a room' do
      association = described_class.reflect_on_association(:room)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  context 'ransackable attributes' do
    it 'returns correct ransackable attributes' do
      expect(Booking.ransackable_attributes).to include('check_in_date', 'check_out_date', 'room_id', 'user_id',
                                                        'status')
    end
  end

  context 'ransackable associations' do
    it 'returns correct ransackable associations' do
      expect(Booking.ransackable_associations).to include('room', 'user')
    end
  end
end
