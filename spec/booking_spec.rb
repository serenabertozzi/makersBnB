require 'pg'
require 'booking'
require 'database_helpers'

describe Booking do
  let(:host_user_id) { create_host } # from database_helpers
  let(:bnb_id) { create_bnb(host_user_id) } # isolates this class for testing
  let(:booking) {
    Booking.create(
      start_date: Time.new(2021, 11),
      end_date: Time.new(2021, 12),
      bnb_id: bnb_id,
      user_id: host_user_id
    )
  }
  before { booking } # create a new booking (and object) that can be referenced with 'booking'

  describe '.create' do
    it 'creates a new booking' do
      persisted_data = persisted_data(table: 'bookings', id: booking.id)

      expect(booking).to be_a Booking
      expect(booking.id).to eq persisted_data['id']
      expect(booking.start_date).to eq "2021-11-01"
      expect(booking.end_date).to eq "2021-12-01"
      expect(booking.bnb_id).to eq bnb_id
      expect(booking.user_id).to eq host_user_id
    end
  end
  
  describe '.find' do
    it 'finds a specific booking' do
      result = Booking.find(id: booking.id)

      expect(result.start_date).to eq booking.start_date
      expect(result.end_date).to eq booking.end_date
      expect(result.bnb_id).to eq booking.bnb_id
      expect(result.user_id).to eq booking.user_id
    end
  end

  describe '.find_by_user' do
    it 'finds all bookings matching a user_id, sorted by newest start_date' do
      booking2 = Booking.create(
        start_date: Time.new(2022, 1),
        end_date: Time.new(2022, 2),
        bnb_id: bnb_id,
        user_id: host_user_id
      )
      booking3 = Booking.create(
        start_date: Time.new(2022, 3),
        end_date: Time.new(2022, 4),
        bnb_id: bnb_id,
        user_id: host_user_id
      )

      result = Booking.find_by_user(user_id: host_user_id)

      expect(result.length).to eq 3
      expect(result[0].user_id).to eq host_user_id
      expect(result[1].user_id).to eq host_user_id
      expect(result[2].user_id).to eq host_user_id
      expect(result[0].id).to eq booking3.id
      expect(result[1].id).to eq booking2.id
      expect(result[2].id).to eq booking.id
    end
  end

  describe '.find_by_bnb' do
    it 'finds all bookings matching a bnb_id, sorted by newest start_date' do
      booking2 = Booking.create(
        start_date: Time.new(2022, 1),
        end_date: Time.new(2022, 2),
        bnb_id: bnb_id,
        user_id: host_user_id
      )
      booking3 = Booking.create(
        start_date: Time.new(2022, 3),
        end_date: Time.new(2022, 4),
        bnb_id: bnb_id,
        user_id: host_user_id
      )

      result = Booking.find_by_bnb(bnb_id: bnb_id)

      expect(result.length).to eq 3
      expect(result[0].bnb_id).to eq bnb_id
      expect(result[1].bnb_id).to eq bnb_id
      expect(result[2].bnb_id).to eq bnb_id
      expect(result[0].id).to eq booking3.id
      expect(result[1].id).to eq booking2.id
      expect(result[2].id).to eq booking.id
    end
  end

  describe '.update' do
    it 'updates a booking start_date and end_date' do
      Booking.update(
        start_date: Time.new(2022, 1),
        end_date: Time.new(2022, 2),
        id: booking.id
      )

      booking_after_update = persisted_data(table: 'bookings', id: booking.id)
      # necessary because calling 'booking' refers to the entry in the let block (unchanged)

      expect(booking_after_update['start_date']).to eq "2022-01-01"
      expect(booking_after_update['end_date']).to eq "2022-02-01"
    end
  end

  describe '.delete' do
    it 'deletes a specific booking' do
      Booking.delete(id: booking.id)
      
      expect(Booking.find(id: booking.id)).to eq nil
    end
  end
end
