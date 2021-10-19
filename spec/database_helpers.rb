require 'pg'

def persisted_data(table:, id:)
  connection = PG.connect(dbname: 'makersbnb_test')
  result = connection.exec("SELECT * FROM #{table} WHERE id = #{id};")
  result.first
end
