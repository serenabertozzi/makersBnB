require_relative "database_connection"
require './spec/setup_connection'
require 'bcrypt'

class User

	attr_reader :id, :email, :first_name, :last_name, :host

  def initialize(id:, first_name:, last_name:, host:, email:)
    @id = id
    @first_name = first_name
    @last_name = last_name
    @host = host
    @email = email

  end

  def self.create(email:, first_name:, last_name:, host:, password:, password_confirmation:)
    return false if DatabaseConnection.query("SELECT * FROM users WHERE email = $1;", [email])
    # must check for duplicate before SQL:"INSERT INTO users"

    encrypted_password = BCrypt::Password.create(password)
    result = DatabaseConnection.query(
      "INSERT INTO users (email, first_name, last_name, host, password) 
      VALUES($1, $2, $3, $4, $5) RETURNING id, email, first_name, last_name, host;", 
      [email, first_name, last_name, host, encrypted_password])
     return false unless password_confirmation?(password, password_confirmation) 
    User.new(
      id: result.first['id'], 
      email: result.first['email'], 
      first_name: result.first['first_name'], 
      last_name: result.first['last_name'], 
      host: result.first['host'])
  end

  def self.log_in(email:, password:)
    result = DatabaseConnection.query("SELECT * FROM users WHERE email = $1;", [email])
    return false unless BCrypt::Password.new(result.first['password']) == password
    User.new(id: result.first['id'], email: result.first['email'], first_name: result.first['first_name'], last_name: result.first['last_name'], host: result.first['host'])
  end

  def self.find(id:)
    result = DatabaseConnection.query("SELECT * FROM users WHERE id = $1;", [id])
    User.new(id: result.first['id'], email: result.first['email'], first_name: result.first['first_name'], last_name: result.first['last_name'], host: result.first['host'])
  end

  def bnb(bnb_class = Bnb)
    bnb_class.find(user_id: id)
  end

  private 

  def self.password_confirmation?(password, password_confirmation)
	password == password_confirmation
  end

end