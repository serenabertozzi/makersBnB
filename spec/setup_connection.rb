require 'pg'

p 'Connecting to database..'

if ENV['ENVIRONMENT'] == 'test'
  PG.connect(dbname: 'makersbnb_test')
else
  PG.connect(dbname: 'makersbnb')
end
