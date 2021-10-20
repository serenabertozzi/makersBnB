require_relative 'database_connection'
require_relative 'bnb'
require_relative 'booking'

class Search
  attr_reader :bnb_id, :name, :location, :price, :host_id

  def initialize(bnb_id:, name:, location:, price:, host_id:)
    @bnb_id = bnb_id
    @name = name
    @location = location
    @price = price
    @host_id = host_id
  end

  def self.filter(location:, min_price:, max_price:)
    results = DatabaseConnection.query(
      "SELECT * from bnbs
      WHERE LOWER(location) = $1
      AND price BETWEEN $2 AND $3
      ;", [location.downcase, min_price, max_price] # making it case insensitive
    )
    return unless results.any?
    results.map do |result| 
      Search.new(
        bnb_id: result['id'], name: result['name'], location: result['location'],
        price: result['price'], host_id: result['host_id']
      )
    end
  end
end
