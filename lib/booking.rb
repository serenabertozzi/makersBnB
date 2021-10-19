require_relative 'database_connection'

class Booking

  attr_reader :id, :start_date, :end_date, :bnb_id, :user_id
  
  def initialize(id:, start_date:, end_date:, bnb_id:, user_id:)
    @id = id
    @start_date = start_date
    @end_date = end_date
    @bnb_id = bnb_id
    @usr_id = user_id
  end

  def self.create(start_date:, end_date:, bnb_id:, user_id:)
    result = DatabaseConnection.query(
      "INSERT INTO bookings(start_date, end_date, bnb_id, user_id) VALUES($1, $2, $3, $4) RETURNING *;",
      [start_date, end_date, bnb_id, user_id]
    )
    
    booking.new(id: result[0]['id'], start_date: result[0]['start_date'], end_date: result[0]['end_date'],
    bnb_id: result[0]['bnb_id'], user_id: result[0]['user_id'])
  end

  def self.all
    result = DatabaseConnection.query("SELECT * FROM bookings;")

    result.map do |booking| 
      Booking.new(id: booking['id'], start_date: booking['start_date'], end_date: booking['end_date'],
      bnb_id: booking['bnb_id'], user_id: booking['user_id'])
    end.sort_by { |booking| booking.start_date }.reverse
  end

  def self.find(id:)
    result = DatabaseConnection.query(
      "SELECT * FROM bookings WHERE id = $1;", [id]
    )
    return unless result.any?

    booking.new(id: result[0]['id'], start_date: result[0]['start_date'], end_date: result[0]['end_date'],
    bnb_id: result[0]['bnb_id'], user_id: result[0]['user_id'])
  end

  update

  delete




end

