require 'sinatra/base'
require 'uri'
require 'geocoder'
require 'json'

# http://www.sinatrarb.com/
class App < Sinatra::Base

  # auth taken directly from http://www.sinatrarb.com/faq.html#auth
  helpers do
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['Busbud', 'password123']
    end
  end


  # Endpoints
  get '/suggestions' do
    protected!
    content_type :json

    @results = Array.new

    # Use google geocoder only
    Geocoder.configure(:lookup => :google)
    # Convert each result into the format we need (name, latitude, longitude)
    Geocoder.search(params[:q]).each do |result|
      # this should be broken out into a class to hold exactly the attributes we need
      # many more names and other info is available
      result = {
        :name => result.address,
        :latitude => result.coordinates[0],
        :longitude => result.coordinates[1]
      }
      @results.push(result)
    end
    
    if @results.length == 0
      status 404
    end
    
    #return the results array (including an empty array on 404)
    {:results => @results}.to_json
  end
end