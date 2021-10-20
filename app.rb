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
  enable :method_override

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

  post "/log_out" do
    session[:user_id] = nil
    redirect "/"
  end

  # Please use below for log out
  #<form action='/log_out' method="post">
  #	<input type="submit" value="Logout" style="width:100px;height:30px;">
  #  </form>

  get "/user/login" do
    erb(:"user/login")
  end

  post "/user/login" do
    user = User.log_in(email: params[:email], password: params[:password])
    unless user
      flash[:notice] = "Password did not match, please try again"
      redirect(:'user/login')
    else
      session[:user_id] = user.id
      redirect "/"
    end
  end

  get '/user/dashboard' do 
    @user_id = session[:user_id]
    @bnb = Bnb.where(user_id: session[:user_id])
    erb(:'user/dashboard')
  end

  get '/user/dashboard/:id/bnb/new' do
    @user_id = params[:id]
    erb :'bnb/new'
  end

  post '/user/dashboard/:id/bnb' do
    Bnb.create(name: params[:name], location: params[:location], price: params[:price], user_id: params[:id])
    redirect 'user/dashboard'
  end

  run! if app_file == $0
end
