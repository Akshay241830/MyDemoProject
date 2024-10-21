require 'rails_helper'

RSpec.describe Hotel, type: :model do
  context 'validations' do
    it 'validates presence of name' do
      hotel = Hotel.new(name: nil, location: 'Vijay Naggar')
      expect(hotel).not_to be_valid
      expect(hotel.errors[:name]).to include("can't be blank")
    end

    it 'validates uniqueness of name scoped to location' do
      # Create a hotel with a specific name and location
      Hotel.create!(name: 'Amar Villas', location: 'Vijay Naggar')

      # Attempt to create another hotel with the same name and location
      duplicate_hotel = Hotel.new(name: 'Amar Villas', location: 'Vijay Naggar')

      # Run validations
      duplicate_hotel.valid?

      # Check for validation error
      expect(duplicate_hotel.errors[:name]).to include('A hotel with this name and location already exists.')
    end

    it 'allows duplicate names in different locations' do
      # Create a hotel with a specific name and location
      Hotel.create!(name: 'Amar Villas', location: 'Vijay Naggar')

      # Create another hotel with the same name but different location
      new_hotel = Hotel.new(name: 'Amar Villas', location: 'Rajiv Chowk')

      # Run validations
      expect(new_hotel).to be_valid
    end
  end
end

# require 'rails_helper'

# # frozen_string_literal: true

# describe  Hotel, type: :model do
#   Hotel.create!(name: 'Amar Villas', location: 'Vijay Nagar')
#   hotel = Hotel.new(name: 'Amar Villas', location: 'Vijay Nagar')
#   hotel.valid?
#   expect(hotel.errors[:name, :location]).to include('has already been taken')
# end
