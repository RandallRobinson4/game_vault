require './config/environment'
require 'rack-flash'

class ConsoleController < Sinatra::Base
  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/consoles' do
    if logged_in?
      erb :'consoles/index'
    else
      redirect '/login'
    end
  end

  get '/consoles/new' do
    if logged_in?
      erb :'consoles/new'
    else
      redirect '/login'
    end
  end

  post '/consoles' do
    @console = Console.new(name: params[:name], user_id: session[:id])
    if @console.valid?
      @console.save
      redirect "/consoles"
    else
      flash[:message] = "Error! Console must have a name!"
      redirect '/consoles/new'
    end
  end





  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find(session[:id]) if session[:id]
    end
  end
end
