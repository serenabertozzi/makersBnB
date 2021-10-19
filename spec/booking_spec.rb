require 'booking'

describe Booking do
  describe '.create' do
    it 'creates a new booking' do
      user = User.create(
        ##############
      )

      booking = Booking.create(start_date:, end_date:, bnb_id:, user_id:)
      persisted_data = persisted_data(table: 'bookings', id: booking.id)
      # persisted_data queries the database and checks what is actually stored

      expect(booking).to be_a booking
      expect(booking.id).to eq persisted_data['id']
      expect(booking.text).to eq 'Test tweet'
      expect(booking.time).to eq time
      expect(booking.author).to eq user.id
      # replying_to can be NULL
    end
  end

  describe '.all' do
    it 'returns an array of all bookings' do
      user = User.create( # is there a way to DRY this?
        first_name: 'Test', last_name: 'User', username: 'test123',
        email: 'test@test.com', password: '12345'
      )
      booking.create(text: 'Other tweet', author: user.id)
      booking.create(text: 'Another tweet', author: user.id)
      booking = booking.create(text: 'Test tweet', author: user.id)
      bookings = booking.all
      
      expect(bookings.length).to eq(3)
      expect(bookings.first.id).to eq booking.id
      expect(bookings.first.text).to eq 'Test tweet' # the last tweet made is the first in the array
      # storing booking time isn't tested here as it is tested elsewhere
    end

    it 'is sorted in reverse chronological order' do
      user = User.create(
        first_name: 'Test', last_name: 'User', username: 'test123',
        email: 'test@test.com', password: '12345'
      )

      [2019,2020,2021].each do |year|
        Timecop.freeze(Time.new(year))
        booking.create(text: "Test tweet #{year}", author: user.id)
      end
      bookings = booking.all

      expect(bookings.first.time).to eq Timecop.freeze(Time.utc(2021))
      expect(bookings.first.text).to eq "Test tweet 2021"
    end
  end

  describe '.replies' do
    it 'returns an array of all replies to a specific booking' do
      user1 = User.create(
        first_name: 'Test', last_name: 'User', username: 'test1',
        email: 'test1@test.com', password: '12345'
      )
      user2 = User.create(
        first_name: 'Test', last_name: 'User', username: 'test2',
        email: 'test2@test.com', password: '12345'
      )
      user3 = User.create(
        first_name: 'Test', last_name: 'User', username: 'test3',
        email: 'test3@test.com', password: '12345'
      )
      
      booking = booking.create(text: 'Test tweet', author: user1.id)
      reply_booking1 = booking.create(text: 'Reply tweet1', author: user2.id, booking: booking.id)
      reply_booking2 = booking.create(text: 'Reply tweet2', author: user3.id, booking: booking.id)
      replies = booking.replies(id: booking.id)

      expect(replies.length).to eq(2)
      expect(replies.first.id).to eq reply_booking2.id
      expect(replies.first.text).to eq 'Reply tweet2' # newest first
    end
  end
end
