require 'pg'

task :delete do

  ['makersbnb', 'makersbnb_test'].each do |database|
    connection = PG.connect
    connection.exec("SELECT pg_terminate_backend (pg_stat_activity.pid)
    FROM pg_stat_activity
    WHERE pg_stat_activity.datname = '#{database}';") # terminates active db connection
    connection.exec("DROP DATABASE #{database};") # deletes db
  end
  
  p "Deleted"
end


task :setup do

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
        price smallint NOT NULL,
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

task :setup_test_database do
  p "Resetting test database..."
  
  connection = PG.connect(dbname: 'makersbnb_test')

  connection.exec("TRUNCATE TABLE users, bnbs, bookings;")
end
