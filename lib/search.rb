require_relative 'database_connection'
require_relative 'bnb'
require_relative 'booking'

class Search
  attr_reader :bnb_id, :name, :location, :price, :user_id

  def initialize(bnb_id:, name:, location:, price:, user_id:)
    @bnb_id = bnb_id
    @name = name
    @location = location
    @price = price
    @user_id = user_id
  end

  def self.filter(location: "", min_price: '0', max_price: '10000', start_date: nil, end_date: nil)
    # html passes empty form inputs as "", default arguments are kept for easier testing
    location ||= ""
    min_price = '0' if min_price == "" || min_price.nil?
    max_price = '10000' if max_price == "" || max_price.nil?
    start_date = Time.new(1900) if start_date == "" || start_date.nil?
    end_date = Time.new(1900) if end_date == "" || end_date.nil?
 
    unless location.empty?
      results = DatabaseConnection.query(
        "SELECT id, name, location, price, user_id
        FROM bnbs
        WHERE LOWER(bnbs.location) = $1
        AND price BETWEEN $2 AND $3
        ;", [location.downcase, min_price, max_price]
      )
    else
      results = DatabaseConnection.query(
        "SELECT id, name, location, price, user_id
        FROM bnbs
        WHERE price BETWEEN $1 AND $2
        ;", [min_price, max_price]
      )
    end
    return unless results.any?
    bnbs = results.map do |result|
      Search.new(
        bnb_id: result['id'], name: result['name'], location: result['location'],
        price: result['price'], user_id: result['user_id']
      )
    end

    bnbs.select do |bnb|
      Bnb.available?(bnb_id: bnb.bnb_id, start_date: start_date, end_date: end_date)
    end
  end
end
