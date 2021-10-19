describe Bnb do

  
  describe '.create' do
    it 'creates a new bnb' do

      bnb = Bnb.create(name:'The Shard', location: 'London', price: '300', user_id: '001' )
      persisted_data = persisted_data(table: 'bnbs', id: bnb.id)

      expect(bnb).to be_a Bnb
      expect(bnb.id).to eq persisted_data.first['id']
      expect(bnb.name).to eq 'The Shard'
      expect(bnb.location).to eq 'London'
      expect(bnb.price).to eq '300'
      expect(bnb.user_id).to eq '001'
    end
  end

end