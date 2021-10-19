require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/flash'
require './lib/user'
require './lib/booking'
require './lib/bnb'

class Makersbnb < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  enable :sessions
  register Sinatra::Flash

  get '/' do
    @user = User.find(id: session[:user_id]) if session[:user_id]
    erb(:index)
  end

  get '/user' do 
    erb(:'user/index')
  end

  post '/user' do
    user = User.create(username: params[:username], password: params[:password], password_confirmation: params[:password_confirmation])
    unless user
      flash[:notice] = "Password did not match or email already exists" 
      redirect(:'user')
    else
      session[:user_id] = user.id
      redirect "/"
    end
  end

  run! if app_file == $0
end
