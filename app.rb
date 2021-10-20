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
      redirect "/user"
    else
      session[:user_id] = user.id
      redirect "/"
    end
  end

  post "/log_out" do
    session[:user_id] = nil
    redirect "/"
  end

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

  get "/user/dashboard" do
    @user_id = session[:user_id]
    @user = User.find(id: @user_id) if @user_id
    if @user.host != "f"
      @bnb = Bnb.where(user_id: session[:user_id])
      erb(:'user/dashboard')
    else
      def find_hotel(id)
        Bnb.find(id: id).name
      end
      @booking = Booking.find_by_user(user_id: @user_id)
      erb(:'user/guest_dashboard')
    end
  end

  get "/user/dashboard/:id/bnb/new" do
    @user_id = params[:id]
    erb :'bnb/new'
  end

  post "/user/dashboard/:id/bnb" do
    Bnb.create(name: params[:name], location: params[:location], price: params[:price], user_id: params[:id])
    redirect "user/dashboard"
  end

  get "/listings/all" do
    @bnb = Bnb.all
    erb :'listings/all'
  end

  get "/listings/bnb/:id" do
    @bnb = Bnb.find(id: params[:id])
    erb :'listings/bnb'
  end

  delete "/user/dashboard/:id/bnb/:bnb_id" do
    Bnb.delete(id: params[:bnb_id])
    redirect "user/dashboard"
  end

  get "/user/dashboard/:id/bnb/:bnb_id/edit" do
    @user_id = session[:user_id]
    @bnb = Bnb.find(id: params[:bnb_id])
    erb :"bnb/edit"
  end

  patch "/user/dashboard/:id/bnb/:bnb_id" do
    Bnb.update(id: params[:bnb_id], name: params[:name], location: params[:location], price: params[:price])
    redirect "user/dashboard"
  end

  delete '/user/dashboard/:id/booking/:booking_id' do
    Bnb.delete(id: params[:booking_id])
    redirect 'user/guest_dashboard'
  end

  run! if app_file == $0
end
