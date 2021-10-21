require 'pg'

def persisted_data(table:, id:)
  connection = PG.connect(dbname: 'makersbnb_test')
  result = connection.exec("SELECT * FROM #{table} WHERE id = #{id};")
  result.first
end

# methods below are for isolating each model, relying on PG instead

def create_host
  connection = PG.connect(dbname: 'makersbnb_test')
  host_user_result = connection.exec(
    "INSERT INTO users(first_name, last_name, email, password, host)
    VALUES('Guest', 'User', 'test@example.com', '12345', 'true') RETURNING *;"
  )
  host_user_result[0]['id']
end

def create_bnb(host_id:, name: 'Test BNB', location: 'London', price: '30')
  connection = PG.connect(dbname: 'makersbnb_test')
  bnb_result = connection.exec(
    "INSERT INTO bnbs(name, location, price, user_id)
    VALUES('#{name}', '#{location}', #{price}, #{host_id}) RETURNING *;"
  )
  bnb_result[0]['id']
end

def create_booking(bnb_id:, user_id:, start_date:, end_date:)
  connection = PG.connect(dbname: 'makersbnb_test')
  booking_result = connection.exec(
    "INSERT INTO bookings(start_date, end_date, bnb_id, user_id)
    VALUES('#{start_date}', '#{end_date}', #{bnb_id}, #{user_id}) RETURNING *;",
  )
end
