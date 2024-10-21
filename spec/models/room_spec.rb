require 'rails_helper'

RSpec.describe Room, type: :model do
  # Factories (if using FactoryBot)
  let(:hotel) { Hotel.create(name: 'Grand Hotel', location: 'Downtown') }
  let(:room) { Room.new(room_type: 'Deluxe', status: 'Available', hotel: hotel) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(room).to be_valid
    end

    it 'is not valid without a room_type' do
      room.room_type = nil
      room.valid?
      expect(room.errors[:room_type]).to include("can't be blank")
    end

    it 'is not valid without a status' do
      room.status = nil
      room.valid?
      expect(room.errors[:status]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a hotel' do
      assoc = described_class.reflect_on_association(:hotel)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it 'has many bookings' do
      assoc = described_class.reflect_on_association(:bookings)
      expect(assoc.macro).to eq(:has_many)
    end

    it 'has many users through bookings' do
      assoc = described_class.reflect_on_association(:users)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:through]).to eq(:bookings)
    end
  end
end
