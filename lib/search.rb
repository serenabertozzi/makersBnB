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

  def self.filter(location: "", min_price: '0', max_price: '10000', start_date: Time.new(1900), end_date: Time.new(2100))
    location ||= ""
    min_price = '0' if max_price == "" || min_price.nil?
    max_price = '10000' if max_price == "" || max_price.nil?
    start_date ||= Time.new(1900)
    end_date ||= Time.new(2100)
    unless location.empty?
      results = DatabaseConnection.query(
        "SELECT bnbs.id, bnbs.name, bnbs.location, bnbs.price, bnbs.user_id, bookings.start_date, bookings.end_date
        FROM bnbs
        LEFT JOIN bookings
        ON bnbs.id = bookings.bnb_id
        WHERE LOWER(bnbs.location) = $1
        AND price BETWEEN $2 AND $3
        AND (bookings.start_date IS NULL
          OR bookings.start_date NOT BETWEEN $4 AND $5)
        AND (bookings.end_date IS NULL
          OR bookings.end_date NOT BETWEEN $4 AND $5)
        ;", [location.downcase, min_price, max_price, start_date, end_date]
      )
    else
      results = DatabaseConnection.query(
        "SELECT bnbs.id, bnbs.name, bnbs.location, bnbs.price, bnbs.user_id, bookings.start_date, bookings.end_date
        FROM bnbs
        LEFT JOIN bookings
        ON bnbs.id = bookings.bnb_id
        WHERE price BETWEEN $1 AND $2
        AND (bookings.start_date IS NULL
          OR bookings.start_date NOT BETWEEN $3 AND $4)
        AND (bookings.end_date IS NULL
          OR bookings.end_date NOT BETWEEN $3 AND $4)
        ;", [min_price, max_price, start_date, end_date]
      )
    end
    return unless results.any?
    results.map do |result|
      Search.new(
        bnb_id: result['id'], name: result['name'], location: result['location'],
        price: result['price'], user_id: result['user_id']
      )
    end
  end
end
