require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/flash'

class Makersbnb < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  enable :sessions
  register Sinatra::Flash

  get '/' do
    'makersbnb'
  end

  run! if app_file == $0
end
