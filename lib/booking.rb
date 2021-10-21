require_relative 'database_connection'

class Booking

  attr_reader :id, :start_date, :end_date, :bnb_id, :user_id
  
  def initialize(id:, start_date:, end_date:, bnb_id:, user_id:)
    @id = id
    @start_date = start_date
    @end_date = end_date
    @bnb_id = bnb_id
    @user_id = user_id
  end

  def self.create(start_date:, end_date:, bnb_id:, user_id:)
    result = DatabaseConnection.query(
      "INSERT INTO bookings(start_date, end_date, bnb_id, user_id)
      VALUES($1, $2, $3, $4) RETURNING *;",
      [start_date, end_date, bnb_id, user_id]
    )

    Booking.new(
      id: result[0]['id'], start_date: result[0]['start_date'], end_date: result[0]['end_date'],
      bnb_id: result[0]['bnb_id'], user_id: result[0]['user_id']
    )
  end

  def self.find(id:)
    result = DatabaseConnection.query(
      "SELECT * FROM bookings WHERE id = $1;", [id]
    )
    return unless result.any?

    Booking.new(
      id: result[0]['id'], start_date: result[0]['start_date'], end_date: result[0]['end_date'],
      bnb_id: result[0]['bnb_id'], user_id: result[0]['user_id']
    )
  end

  def self.find_by_user(user_id:)
    result = DatabaseConnection.query(
      "SELECT * FROM bookings WHERE user_id = $1;", [user_id]
    )
    return unless result.any?

    result.map do |booking| 
      Booking.new(
        id: booking['id'], start_date: booking['start_date'], end_date: booking['end_date'],
        bnb_id: booking['bnb_id'], user_id: booking['user_id']
      )
    end.sort_by { |booking| booking.start_date }.reverse
  end

  def self.find_by_bnb(bnb_id:)
    result = DatabaseConnection.query(
      "SELECT * FROM bookings WHERE bnb_id = $1;", [bnb_id]
    )
    return unless result.any?

    result.map do |booking| 
      Booking.new(
        id: booking['id'], start_date: booking['start_date'], end_date: booking['end_date'],
        bnb_id: booking['bnb_id'], user_id: booking['user_id']
      )
    end.sort_by { |booking| booking.start_date }.reverse
  end

  def self.find_all_bookings()
    # all bookings where the host is the owner
    # return who booked it
  end

  def self.update(id:, start_date:, end_date:)
    result = DatabaseConnection.query(
      "UPDATE bookings SET start_date = $1, end_date = $2
      WHERE id = $3 RETURNING *;", 
      [start_date, end_date, id]
    )

    Booking.new(
      id: result[0]['id'], start_date: result[0]['start_date'], end_date: result[0]['end_date'],
      bnb_id: result[0]['bnb_id'], user_id: result[0]['user_id']
    )
  end

  def self.delete(id:)
    result = DatabaseConnection.query(
      "DELETE FROM bookings WHERE id = $1 RETURNING *;", [id]
    )

    Booking.new(
      id: result[0]['id'], start_date: result[0]['start_date'], end_date: result[0]['end_date'],
      bnb_id: result[0]['bnb_id'], user_id: result[0]['user_id']
    )
  end
end
