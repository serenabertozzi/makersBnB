require 'pg'

task :setup do
  p "Creating databases..."

  ['makersbnb', 'makersbnb_test'].each do |database|
    connection = PG.connect
    connection.exec("CREATE DATABASE #{database};")
    connection = PG.connect(dbname: database)
    connection.exec(
      "CREATE TABLE users(
        id SERIAL PRIMARY KEY,
        first_name varchar(20) NOT NULL,
        last_name varchar(20) NOT NULL,
        email varchar(50) UNIQUE NOT NULL,
        password varchar(100) NOT NULL,
        host boolean NOT NULL
        );"
    )
    connection.exec(
      "CREATE TABLE bnbs(
        id SERIAL PRIMARY KEY,
        name varchar(50) NOT NULL,
        location varchar(50),
        user_id INT NOT NULL,
        FOREIGN KEY (user_id)
        REFERENCES users (id)
       );"
    )

    connection.exec(
      "CREATE TABLE bookings(
        id SERIAL PRIMARY KEY,
        start_date Date NOT NULL,
        end_date Date NOT NULL,
        bnb_id INT NOT NULL,
        user_id INT NOT NULL,
        FOREIGN KEY (bnb_id)
        REFERENCES bnbs (id),
        FOREIGN KEY (user_id)
        REFERENCES users (id)
       );"
    )

    p 'Success!'
  end
end
