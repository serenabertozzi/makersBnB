require 'search'
require 'database_helpers'

describe Search do
  let(:host_user_id) { create_host }
  let(:london_bnb1) { create_bnb(host_id: host_user_id, name: 'London 1', location: 'London', price: '20') }
  let(:london_bnb2) { create_bnb(host_id: host_user_id, name: 'London 2', location: 'London', price: '30') }
  let(:london_bnb3) { create_bnb(host_id: host_user_id, name: 'London 3', location: 'London', price: '40') }
  let(:manchester_bnb1) { create_bnb(host_id: host_user_id, name: 'Manchester 1', location: 'Manchester', price: '50') }
  let(:manchester_bnb2) { create_bnb(host_id: host_user_id, name: 'Manchester 2', location: 'Manchester', price: '70') }
  before do
    london_bnb1
    london_bnb2
    london_bnb3
    manchester_bnb1
    manchester_bnb2
  end

  describe '.filter' do
    it 'can filter by location' do 
      result = Search.filter(location: 'London')
      result_bnbs = result.map { |result| result.bnb_id }
      expect(result_bnbs).to include london_bnb1
      expect(result_bnbs).to include london_bnb2
      expect(result_bnbs).to include london_bnb3
      expect(result_bnbs).not_to include manchester_bnb1
      expect(result_bnbs).not_to include manchester_bnb2

      result2 = Search.filter(location: 'manchester') # case insensitive
      result2_bnbs = result2.map { |result| result.bnb_id }
      expect(result2_bnbs).to include manchester_bnb1
      expect(result2_bnbs).to include manchester_bnb2
      expect(result2_bnbs).not_to include london_bnb1
      expect(result2_bnbs).not_to include london_bnb2
      expect(result2_bnbs).not_to include london_bnb3
    end
    
    it 'can filter by price' do
      result = Search.filter(min_price: '40', max_price: '50')
      result_bnbs = result.map { |result| result.bnb_id }
      expect(result_bnbs).to include london_bnb3
      expect(result_bnbs).to include manchester_bnb1
      expect(result_bnbs).not_to include london_bnb1
      expect(result_bnbs).not_to include london_bnb2
      expect(result_bnbs).not_to include manchester_bnb2
    end

    it 'can filter by location and price' do
      result = Search.filter(location: 'London', min_price: '10', max_price: '30')
      result_bnbs = result.map { |result| result.bnb_id }
      expect(result_bnbs).to include london_bnb1
      expect(result_bnbs).to include london_bnb2
      expect(result_bnbs).not_to include london_bnb3
      expect(result_bnbs).not_to include manchester_bnb1
      expect(result_bnbs).not_to include manchester_bnb2
    end

    it 'returns nil if no matches' do
      result = Search.filter(location: 'Birmingham', min_price: '1', max_price: '100')
      expect(result).to eq nil
    end

    it 'can filter by date availability' do
      create_booking(bnb_id: london_bnb1, user_id: host_user_id, start_date: Time.new(2021, 2), end_date: Time.new(2021, 3))

      result = Search.filter(start_date: Time.new(2021, 1), end_date: Time.new(2021, 4))
      result_bnbs = result.map { |result| result.bnb_id }
      
      expect(result_bnbs).not_to include london_bnb1
      expect(result_bnbs).to include london_bnb2
    end
  end
end
