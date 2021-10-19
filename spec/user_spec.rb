require "user"
require_relative "database_helpers"

describe User do

     describe '.create' do
      it 'does not create a new user if the email is taken' do
        User.create(email: 'test@test.com', first_name: 'Name', last_name: 'Surname', host: true, password: '123457jghjhgj', password_confirmation: '123457jghjhgj')
        user = User.create(email: 'test@test.com', first_name: 'Name', last_name: 'Surname', host: true, password: '123457jghjhgj', password_confirmation: '123457jghjhgj')
        expect(user).to be_falsy
      end
    end
  
    describe '.find' do
      it 'returns the requested user object' do
        user = User.create(email: 'test@test.com', first_name: 'Name', last_name: 'Surname', host: true, password: '123457jghjhgj', password_confirmation: '123457jghjhgj')
  
        result = User.find(id: user.id)
        persisted_data = persisted_data(table: 'users', id: user.id )
  
        expect(result).to be_a User
        expect(result.id).to eq user.id
        expect(result.id).to eq persisted_data['id']
        expect(result.email).to eq persisted_data['email']
        expect(result.first_name).to eq persisted_data['first_name']
        expect(result.last_name).to eq persisted_data['last_name']
        expect(result.host).to eq persisted_data['host']
        expect(true).to eq (BCrypt::Password.new(persisted_data['password']) == '123457jghjhgj')
        expect(result.email).to eq 'test@test.com'
        expect(result.first_name).to eq 'Name'
        expect(result.last_name).to eq 'Surname'
        expect(result.host).to eq "t"
      end
    end

    describe '.log_in' do
        it 'returns the requested user object on log in' do
          user = User.create(email: 'test@test.com', first_name: 'Name', last_name: 'Surname', host: true, password: '123457jghjhgj', password_confirmation: '123457jghjhgj')
    
          result = User.log_in(email: 'test@test.com', password: '123457jghjhgj')
          persisted_data = persisted_data(table: 'users', id: user.id )
    
          expect(result).to be_a User
          expect(result.id).to eq user.id
          expect(result.id).to eq persisted_data['id']
          expect(result.email).to eq persisted_data['email']
          expect(result.first_name).to eq persisted_data['first_name']
          expect(result.last_name).to eq persisted_data['last_name']
          expect(result.host).to eq persisted_data['host']
          expect(true).to eq (BCrypt::Password.new(persisted_data['password']) == '123457jghjhgj')
          expect(result.email).to eq 'test@test.com'
          expect(result.first_name).to eq 'Name'
          expect(result.last_name).to eq 'Surname'
          expect(result.host).to eq "t"
        end
    end

end