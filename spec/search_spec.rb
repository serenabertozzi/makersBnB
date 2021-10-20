require 'search'
require 'database_helpers'

describe Search do
  let(:host_user_id) { create_host } # from database_helpers
  let(:bnb1_id) { } # isolates this class for testing
  let(:bnb1_id) { }

  it 'returns a list of matching bnbs as objects' do
    bnb1 = create_bnb(host_id: host_user_id, name: 'BNB 1', location: 'London', price: '20')
    bnb2 = create_bnb(host_id: host_user_id, name: 'BNB 2', location: 'London', price: '30')
    bnb3 = create_bnb(host_id: host_user_id, name: 'BNB 3', location: 'London', price: '40')
    bnb4 = create_bnb(host_id: host_user_id, name: 'BNB 4', location: 'London', price: '50')
    bnb5 = create_bnb(host_id: host_user_id, name: 'BNB 5', location: 'London', price: '60')

    result1 = Search.filter(location: 'London', min_price: '1', max_price: '100')
    result1_bnbs = result1.map { |result| result.bnb_id }
    expect(result1_bnbs).to include bnb1
    expect(result1_bnbs).to include bnb2
    expect(result1_bnbs).to include bnb3
    expect(result1_bnbs).to include bnb4
    expect(result1_bnbs).to include bnb5
  end
end
