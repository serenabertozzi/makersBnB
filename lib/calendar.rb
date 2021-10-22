require "json"

class Calendar
  def initialize(bookings)
    @bookings = bookings || []
  end

  def events
    @bookings.map do |booking|
      {
        display: "background",
        start: booking.start_date,
        end: booking.end_date,
        className: "bg-danger",
      }
    end
  end
end
