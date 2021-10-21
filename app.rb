require "sinatra/base"
require "sinatra/reloader"
require "sinatra/flash"
require "./lib/user"
require "./lib/booking"
require "./lib/bnb"
require "./lib/calendar"
require "./lib/search"

class Makersbnb < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    register Sinatra::Flash
  end
  enable :sessions
  enable :method_override

  before do
    @user = User.find(id: session[:user_id]) if session[:user_id]
  end

  get "/" do
    erb(:index)
  end

  get "/search" do
    start_date = Time.new(1900) unless params[:start_date]
    end_date = Time.new(2100) unless params[:end_date]
    @bnbs = Search.filter(
      location: params[:location], min_price: params[:min_price],
      max_price: params[:max_price], start_date: start_date, end_date: end_date,
    )
    erb :search
  end

  get "/user" do
    erb(:'user/index')
  end

  post "/user" do
    user = User.create(first_name: params[:first_name], last_name: params[:last_name], host: params[:host], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
    unless user
      flash[:notice_sign_up] = "Email already exists, or passwords did not match"
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
      flash[:notice_login] = "Password did not match, please try again"
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
      def find_bnb(id)
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
    @user_id = session[:user_id]
    @bookings = Booking.find_by_bnb(bnb_id: params[:id]) if @user
    @dates = Calendar.new
    @bookings.each { |reservation| @dates.table(reservation.start_date, reservation.end_date) } if @user && @bookings
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

  delete "/user/dashboard/:id/booking/:booking_id" do
    Booking.delete(id: params[:booking_id])
    redirect "user/dashboard"
  end

  get "/user/dashboard/:id/booking/:booking_id/edit" do
    @user_id = session[:user_id]
    @booking = Booking.find(id: params[:booking_id])
    erb :"user/edit_booking"
  end

  patch "/user/dashboard/:id/booking/:booking_id" do
    Booking.update(id: params[:booking_id], start_date: params[:start_date], end_date: params[:end_date])
    redirect "user/dashboard"
  end

  get "/user/dashboard/:id/bnb/:bnb_id/booking/:booking_id/edit" do
    @user_id = session[:user_id]
    @booking = Booking.find(id: params[:booking_id])
    erb :"user/edit_booking_by_host"
  end

  patch "/user/dashboard/:id/bnb/:bnb_id/booking/:booking_id" do
    Booking.update(id: params[:booking_id], start_date: params[:start_date], end_date: params[:end_date])
    redirect "listings/bnb/#{params[:bnb_id]}"
  end

  delete "/user/dashboard/:id/bnb/:bnb_id/booking/:booking_id" do
    Booking.delete(id: params[:booking_id])
    redirect "listings/bnb/#{params[:bnb_id]}"
  end

  run! if app_file == $0
end
