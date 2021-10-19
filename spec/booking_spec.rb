require 'pg'
require 'booking'
require 'database_helpers'

describe Booking do
  let(:host_user_id) { create_host } # from database_helpers
  let(:bnb_id) { create_bnb(host_user_id) } # isolates this class for testing

  describe '.create' do
    it 'creates a new booking' do
      booking = Booking.create(
        start_date: Time.new(2021, 11),
        end_date: Time.new(2021, 12),
        bnb_id: bnb_id,
        user_id: host_user_id
      )

      persisted_data = persisted_data(table: 'bookings', id: booking.id)

      expect(booking).to be_a Booking
      expect(booking.start_date).to eq "2021-11-01"
      expect(booking.end_date).to eq "2021-12-01"
      expect(booking.bnb_id).to eq bnb_id
      expect(booking.user_id).to eq host_user_id

      expect(booking.start_date).to eq persisted_data['start_date']
      expect(booking.end_date).to eq persisted_data['end_date']
      expect(booking.bnb_id).to eq persisted_data['bnb_id']
      expect(booking.user_id).to eq persisted_data['user_id']
    end
  end
  
  describe '.find' do
    it 'finds a specific booking' do
      booking = Booking.create(
        start_date: Time.new(2021, 11),
        end_date: Time.new(2021, 12),
        bnb_id: bnb_id,
        user_id: host_user_id
      )

      result = Booking.find(id: booking.id)

      expect(result.start_date).to eq booking.start_date
      expect(result.end_date).to eq booking.end_date
      expect(result.bnb_id).to eq booking.bnb_id
      expect(result.user_id).to eq booking.user_id
    end
  end

  describe '.by_user' do
    it 'finds all bookings matching a user_id' do
      # booking1 = Booking.create(
      #   start_date: Time.new(2021, 11),
      #   end_date: Time.new(2021, 12),
      #   bnb_id: bnb_id,
      #   user_id: host_user_id
      # )
      # booking2 = Booking.create(
      #   start_date: Time.new(2022, 1),
      #   end_date: Time.new(2022, 2),
      #   bnb_id: bnb_id,
      #   user_id: host_user_id
      # )
      # booking3 = Booking.create(
      #   start_date: Time.new(2022, 3),
      #   end_date: Time.new(2022, 4),
      #   bnb_id: bnb_id,
      #   user_id: host_user_id
      # )


    end
  end

  describe '.update' do
    it 'updates a booking start_date and end_date' do
      
    end
  end

  describe '.delete' do
    it 'deletes a specific booking' do

    end
  end
end

