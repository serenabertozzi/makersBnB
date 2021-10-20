require 'search'
require 'database_helpers'

describe Search do
  let(:host_user_id) { create_host }

  it 'returns a list of matching bnbs as objects' do
    london_bnb1 = create_bnb(host_id: host_user_id, name: 'London 1', location: 'London', price: '20')
    london_bnb2 = create_bnb(host_id: host_user_id, name: 'London 2', location: 'London', price: '30')
    london_bnb3 = create_bnb(host_id: host_user_id, name: 'London 3', location: 'London', price: '40')
    manchester_bnb1 = create_bnb(host_id: host_user_id, name: 'Manchester 1', location: 'Manchester', price: '50')
    manchester_bnb2 = create_bnb(host_id: host_user_id, name: 'Manchester 2', location: 'Manchester', price: '70')

    result1 = Search.filter(location: 'London', min_price: '1', max_price: '100')
    result1_bnbs = result1.map { |result| result.bnb_id }
    expect(result1_bnbs).to include london_bnb1
    expect(result1_bnbs).to include london_bnb2
    expect(result1_bnbs).to include london_bnb3
    expect(result1_bnbs).not_to include manchester_bnb1
    expect(result1_bnbs).not_to include manchester_bnb2

    result2 = Search.filter(location: 'Manchester', min_price: '1', max_price: '100')
    result2_bnbs = result2.map { |result| result.bnb_id }
    expect(result2_bnbs).to include manchester_bnb1
    expect(result2_bnbs).to include manchester_bnb2
    expect(result2_bnbs).not_to include london_bnb1
    expect(result2_bnbs).not_to include london_bnb2
    expect(result2_bnbs).not_to include london_bnb3

    result3 = Search.filter(location: 'London', min_price: '10', max_price: '30')
    result3_bnbs = result3.map { |result| result.bnb_id }
    expect(result3_bnbs).to include london_bnb1
    expect(result3_bnbs).to include london_bnb2
    expect(result3_bnbs).not_to include london_bnb3
    expect(result3_bnbs).not_to include manchester_bnb1
    expect(result3_bnbs).not_to include manchester_bnb2

    result4 = Search.filter(location: 'Birmingham', min_price: '1', max_price: '100')
    expect(result4).to eq nil
  end
end
