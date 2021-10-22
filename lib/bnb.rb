require_relative "database_connection"

class Bnb

  attr_reader :id, :name, :location, :price, :description, :user_id
  def initialize(id:, name:, location:, price:, description:, user_id:)
    @id = id
    @name = name
    @location = location
    @price = price
    @description = description
    @user_id = user_id
  end
  
  def self.create(name:, location:, price:, user_id:, description:)
    result = DatabaseConnection.query(
      "INSERT INTO bnbs (name, location, price, user_id, description) VALUES ($1, $2, $3, $4, $5) 
      RETURNING *;", [name, location, price, user_id, description])
    Bnb.new(
      id: result.first['id'], 
      name: result.first['name'], 
      location: result.first['location'],
      price: result.first['price'], 
      description: result.first['description'],
      user_id: result.first['user_id']
    )
  end

  def self.available?(bnb_id:, start_date:, end_date:)
    result = DatabaseConnection.query(
      "SELECT * FROM bookings
      WHERE bnb_id = $1
      AND (($2 BETWEEN start_date AND end_date) OR ($3 BETWEEN start_date AND end_date))
      OR bnb_id = $1 AND ((start_date BETWEEN $2 AND $3) OR (end_date BETWEEN $2 AND $3))
      ;",
      [bnb_id, start_date, end_date]
    )
    !result.any?
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
      description: result.first['description'],
      user_id: result.first['user_id']
    )
  end

  def self.where(user_id:)
    result = DatabaseConnection.query("SELECT * FROM bnbs WHERE user_id = $1;", [user_id])
    return false if result.first == nil
    result.map { |bnb| Bnb.new(
      id: bnb['id'], 
      name: bnb['name'], 
      location: bnb['location'], 
      price: bnb['price'],
      descripton: bnb['description'],
      user_id: bnb['user_id']
    ) }
  end

  def self.update(name:, location:, price:, id:, description:)
    result = DatabaseConnection.query(
      "UPDATE bnbs SET name = $1, location = $2, price = $3, description = $4 WHERE id = $5 
      RETURNING *;", [name, location, price, description, id])
      Bnb.new(
        id: result.first['id'], 
        name: result.first['name'], 
        location: result.first['location'],
        price: result.first['price'], 
        description: result.first['description'],
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
        description: bnb['description'],
        user_id: bnb['user_id']) 
      } 
  end
end
