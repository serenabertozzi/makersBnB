require 'pg'
require './lib/database_connection'

p 'Connecting to database..'

if ENV['ENVIRONMENT'] == 'test'
  PG.connect(dbname: 'makersbnb_test')
  DatabaseConnection.setup('makersbnb_test')
else
  PG.connect(dbname: 'makersbnb')
  DatabaseConnection.setup('makersbnb')
end
