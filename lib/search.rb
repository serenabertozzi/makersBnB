require_relative 'database_connection'
require_relative 'bnb'
require_relative 'booking'

class Search
  attr_reader :bnb_id, :name, :location, :price, :host_id

  @@min = Time.new(1900)
  @@max = Time.new(2100)

  def initialize(bnb_id:, name:, location:, price:, host_id:)
    @bnb_id = bnb_id
    @name = name
    @location = location
    @price = price
    @host_id = host_id
  end


  def self.filter(location: nil, min_price: '0', max_price: '10000', start_date: @@min, end_date: @@max)
    if location
      results = DatabaseConnection.query(
        "SELECT * from bnbs
        WHERE LOWER(location) = $1
        AND price BETWEEN $2 AND $3
        ;", [location.downcase, min_price, max_price] # making it case insensitive
      )
    else
      results = DatabaseConnection.query(
        "SELECT * from bnbs
        WHERE price BETWEEN $1 AND $2
        ;", [min_price, max_price]
      )
    end
    
    return unless results.any?

    results.map do |result| 
      Search.new(
        bnb_id: result['id'], name: result['name'], location: result['location'],
        price: result['price'], host_id: result['host_id']
      )
    end
  end

end
