describe '.find' do
    it 'finds a specific booking' do
      result = Booking.find(id: booking.id)

      expect(result.start_date).to eq booking.start_date
      expect(result.end_date).to eq booking.end_date
      expect(result.bnb_id).to eq booking.bnb_id
      expect(result.user_id).to eq booking.user_id
    end
  end