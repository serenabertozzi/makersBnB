require 'pg'
require 'bnb'
require 'database_helpers'

describe Bnb do

  let (:host_user_id) { create_host }
  let (:bnb) { Bnb.create(
    name:'The Shard', 
    location: 'London', 
    price: '300', 
    user_id: host_user_id) 
  }

  describe '.create' do

    it 'creates a new bnb' do

      bnb
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
        id: bnb.id) 
        bnb_update = persisted_data(table: 'bnbs', id: bnb.id)

      expect(bnb_update['name']).to eq 'Lisbon House'
      expect(bnb_update['location']).to eq 'Lisbon'
      expect(bnb_update['price']).to eq '50'
    end
  end

  describe '.delete' do
    it 'deletes a new bnb' do

      bnb
      Bnb.delete(id: bnb.id)

      expect(Bnb.all.length).to eq 0
    end
  end


  describe '.all' do
    it 'returns all 2 bnbs' do

      bnb
      Bnb.create(
        name:'Second House', 
        location: 'Second City', 
        price: '99', 
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


  





end