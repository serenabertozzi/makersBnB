require "sinatra/base"
require "sinatra/reloader"
require "sinatra/flash"
require "./lib/user"
require "./lib/booking"
require "./lib/bnb"

class Makersbnb < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    register Sinatra::Flash
  end
  enable :sessions

  get "/" do
    @user = User.find(id: session[:user_id]) if session[:user_id]
    erb(:index)
  end

  get "/user" do
    erb(:'user/index')
  end

  post "/user" do
    user = User.create(first_name: params[:first_name], last_name: params[:last_name], host: params[:host], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
    unless user
      flash[:notice] = "Password did not match or email already exists"
      redirect(:'user')
    else
      session[:user_id] = user.id
      redirect "/"
    end
  end

  post '/log_out' do 
    session[:user_id] = nil
    redirect "/"
  end

  # Please use below for log out
  #<form action='/log_out' method="post">
	#	<input type="submit" value="Logout" style="width:100px;height:30px;">
  #  </form>

  get '/log_in' do 
    erb(:log_in)
  end

  post '/log_in' do
    user = User.log_in(email: params[:email], password: params[:password])
    unless user
      flash[:notice] = "Password did not match, please try again" 
      redirect(:'log_in')
    else
      session[:user_id] = user.id
      redirect "/"
    end
  end

  run! if app_file == $0
end
