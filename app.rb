require 'sinatra/base'
require 'geocoder'
require 'json'

require_relative './lib/http_auth'

# http://www.sinatrarb.com/
class App < Sinatra::Base
  register Sinatra::HTTPAuth
  http_basic_authenticate_with :name => "Busbud", :password => "password123"

  get '/suggestions' do
    query = params[:q]

    # See https://github.com/alexreisner/geocoder#advanced-geocoding
    # Default provider is Google, with max of 2.5k requests per day
    locations = Geocoder.search(query)

    if locations.empty?
      res = {
        results: [],
        message: "Could not find city '#{query}'"
      }

      throw(:halt, [404, JSON.dump(res)])
    end

    results = locations.map do |location|
      {
        name: location.address,
        latitude: location.latitude,
        longitude: location.longitude
      }
    end

    JSON.dump({results: results})
  end
end
