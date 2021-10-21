require 'date'
class Calendar
  attr_reader :avalibility
  def initialize
    @avalibility = Array.new
    date = Date.parse('21st Oct 2021')
    while date.year <= 2022
      date += 1 
      @avalibility << [date.strftime('%Y-%m-%d'), true]
    end
  end

  def table(start_date, end_date)
    @avalibility.map do |date| 
      if date.first >= start_date && date.first <= end_date
        date[1] = false
      end
    end
  end
end