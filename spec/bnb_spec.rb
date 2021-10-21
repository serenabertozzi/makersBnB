require 'bnb'
require 'database_helpers'

describe Bnb do

  let (:host_user_id) { create_host }
  let (:bnb) { Bnb.create(
    name:'The Shard', 
    location: 'London', 
    price: '300',
    description: 'wow!',
    user_id: host_user_id) 
  }
  before { bnb }
  # create a new bnb (and object) that can be referenced with 'bnb'

  describe '.create' do
    it 'creates a new bnb' do
      persisted_data = persisted_data(table: 'bnbs', id: bnb.id)

      expect(bnb).to be_a Bnb
      expect(bnb.id).to eq persisted_data['id']
      expect(bnb.name).to eq 'The Shard'
      expect(bnb.location).to eq 'London'
      expect(bnb.price).to eq '300'
      expect(bnb.user_id).to eq host_user_id
    end
  end

  describe '.update' do
    it 'updates an existing bnb' do
      Bnb.update(
        name:'Lisbon House', 
        location: 'Lisbon', 
        price: '50',
        description: 'wow!',
        id: bnb.id) 
        bnb_update = persisted_data(table: 'bnbs', id: bnb.id)

      expect(bnb_update['name']).to eq 'Lisbon House'
      expect(bnb_update['location']).to eq 'Lisbon'
      expect(bnb_update['price']).to eq '50'
    end
  end

  describe '.delete' do
    it 'deletes a new bnb' do
      Bnb.delete(id: bnb.id)

      expect(Bnb.all.length).to eq 0
    end
  end


  describe '.all' do
    it 'returns all 2 bnbs' do
      Bnb.create(
        name:'Second House', 
        location: 'Second City', 
        price: '99',
        description: 'wow!',
        user_id: host_user_id)

      all_listings = Bnb.all
      
      expect(all_listings.length).to eq 2
      expect(all_listings.length).to_not eq 3
      expect(all_listings.first).to be_a Bnb
      expect(all_listings[0].location).to eq "London"
      expect(all_listings[1].location).to eq "Second City"
    end
  end

  describe '.find' do
    it 'finds a bnb' do
      result = Bnb.find(id: bnb.id)

      expect(result.name).to eq 'The Shard'
      expect(result.location).to eq 'London'
      expect(result.price).to eq '300'
    end
  end

  describe '.available?' do
    it 'returns true if the bnb is available within a date range' do
      create_booking(
        bnb_id: bnb.id, user_id: host_user_id, 
        start_date: Time.new(2021, 11), end_date: Time.new(2021, 12)
      )
      # bnb is booked from 2021/11/1 to 2021/12/1

      result1 = Bnb.available?( # start date overlaps
        start_date: Time.new(2021, 11, 15),
        end_date: Time.new(2021, 12, 15),
        bnb_id: bnb.id,
      )
      result2 = Bnb.available?( # end date overlap
        start_date: Time.new(2021, 10, 15),
        end_date: Time.new(2021, 11, 15),
        bnb_id: bnb.id,
      )
      result3 = Bnb.available?( # booking before
        start_date: Time.new(2019, 11, 15),
        end_date: Time.new(2019, 12, 15),
        bnb_id: bnb.id,
      )
      result4 = Bnb.available?( # booking after
        start_date: Time.new(2023, 11, 15),
        end_date: Time.new(2023, 12, 15),
        bnb_id: bnb.id,
      )
      result5 = Bnb.available?( # booking inside the range
        start_date: Time.new(2021, 11, 15),
        end_date: Time.new(2021, 11, 16),
        bnb_id: bnb.id,
      )
      expect(result1).to eq false
      expect(result2).to eq false
      expect(result3).to eq true
      expect(result4).to eq true
      expect(result5).to eq false
    end
  end
end
