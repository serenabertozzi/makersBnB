require_relative "database_connection"

class Bnb

  attr_reader :id, :name, :location, :price, :user_id
  def initialize(id:, name:, location:, price:, user_id:)
    @id = id
    @name = name
    @location = location
    @price = price
    @user_id = user_id
  end
  
  def self.create(name:, location:, price:, user_id:)
    result = DatabaseConnection.query(
      "INSERT INTO bnbs (name, location, price, user_id) VALUES ($1, $2, $3, $4) 
      RETURNING *;", [name, location, price, user_id])
    Bnb.new(
      id: result.first['id'], 
      name: result.first['name'], 
      location: result.first['location'],
      price: result.first['price'], 
      user_id: result.first['user_id']
    )
  end

  def self.delete(id:)
    DatabaseConnection.query("DELETE FROM bnbs WHERE id = $1", [id])
  end

  def self.find(id:)
    result = DatabaseConnection.query("SELECT * FROM bnbs WHERE id = $1;", [id])
    Bnb.new(
      id: result.first['id'], 
      name: result.first['name'], 
      location: result.first['location'], 
      price: result.first['price'], 
      user_id: result.first['user_id']
    )
  end

  def self.where(user_id:)
    result = DatabaseConnection.query("SELECT * FROM bnbs WHERE user_id = $1;", [user_id])
    Bnb.new(
      id: result.first['id'], 
      name: result.first['name'], 
      location: result.first['location'], 
      price: result.first['price'], 
      user_id: result.first['user_id']
    )
  end

  def self.update(name:, location:, price:, id:)
    result = DatabaseConnection.query(
      "UPDATE bnbs SET name = $1, location = $2, price = $3 WHERE id = $4 
      RETURNING *;", [name, location, price, id])
    Bnb.new(
      id: result.first['id'], 
      name: result.first['name'], 
      location: result.first['location'],
      price: result.first['price'], 
      user_id: result.first['user_id']
    )
  end

  def self.all
    result = DatabaseConnection.query("SELECT * FROM bnbs")
    result.map { |bnb| 
      Bnb.new(id: bnb['id'], 
        name: bnb['name'], 
        location: bnb['location'],
        price: bnb['price'], 
        user_id: bnb['user_id']) 
      } 
  end

end