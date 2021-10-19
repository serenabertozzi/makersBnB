require_relative "database_connection"
require 'bcrypt'

class User

	attr_reader :id, :email, :first_name, :last_name, :host_id

  def initialize(id:, first_name:, last_name:, host_id:, email:)
    @id = id
    @first_name = first_name
    @last_name = last_name
    @host_id = host_id
    @email = email

  end

  def self.create(email:, first_name:, last_name:, host_id:, password:, password_confirmation:)
    return false unless password_confirmation?(password, password_confirmation) && !DatabaseConnection.query("SELECT * FROM users WHERE email = $1;", [email]).first
    encrypted_password = BCrypt::Password.create(password)
    result = DatabaseConnection.query("INSERT INTO users (email, first_name, last_name, host_id, password) VALUES($1, $2, $3, $4, $5) RETURNING id, email, first_name, last_name, host_id;", [email, first_name, last_name, host_id, encrypted_password])
    User.new(id: result.first['id'], email: result.first['email'], first_name: result.first['first_name'], last_name: result.first['last_name'], host_id: result.first['host_id'])
  end

  def self.log_in(email:, password:)
    result = DatabaseConnection.query("SELECT * FROM users WHERE email = $1;", [email])
    return false unless BCrypt::Password.new(result.first['password']) == password
    User.new(id: result.first['id'], email: result.first['email'], first_name: result.first['first_name'], last_name: result.first['last_name'], host_id: result.first['host_id'])
  end

  def self.find(id:)
    result = DatabaseConnection.query("SELECT * FROM users WHERE id = $1;", [id])
    User.new(id: result.first['id'], email: result.first['email'], first_name: result.first['first_name'], last_name: result.first['last_name'], host_id: result.first['host_id'])
  end

  def bnb(bnb_class = Bnb)
    bnb_class.where(user_id: id)
  end

  private 

  def self.password_confirmation?(password, password_confirmation)
	password == password_confirmation
  end

end