require 'sinatra/base'
require 'erb'
require 'sinatra'
require 'json'
require 'uri'
require 'net/http'
require 'sinatra/basic_auth'
require 'sinatra/simple_auth'



# http://www.sinatrarb.com/
class App < Sinatra::Base
    @@google_base_url = "http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address="

	# example from sinatra simple authentication
	def authorized?
		@auth ||=  Rack::Auth::Basic::Request.new(request.env)
		@auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ["CUSTOM_USERNAME","SECRET_PASSWORD"]
	end

	# example from sinatra simple authentication
	def protected!
		unless authorized?
		response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
		throw(:halt, [401, "Oops... we need your login name & password\n"])
		end
	end
	
	
	#------------------------------------------------------------------------
	# basic authentication
	def authenticate(user,pass)
		return user=="Busbud" && pass=="password123"
	end
	
	# retrieve google coordinates by passing address specified by user	
	def geocode(address)
	
		uri = URI.encode("#{@@google_base_url}#{address}")
		url = URI.parse(uri)
		http = Net::HTTP.new(url.host, url.port)
		request = Net::HTTP::Get.new(url.request_uri)
		response = http.request(request)	
		# throws exception
		raise "Bad response, code #{response.code}" if response.code != "200"
		
		# result returned from Google Geocoding API
		result = response.body
		json_parsed = JSON.parse(result)
		
		return json_parsed
	end
	
	
	def display_msg(json_parsed)
	
		status = json_parsed['status']
		
		if status =="OK"
			"No errors occurred; the address was successfully parsed and at least one geocode was returned."
			get_coordinates(json_parsed)
		elsif status =="ZERO_RESULTS"
			"Returned no results. Geocode was passed a non-existent address or a latlng in a remote location."
		
		elsif status =="INVALID_REQUEST"
			"Query (address or latlng) is missing."
		
		else
			"UNKNOWN_ERROR "
		end
	end	
	
	def get_coordinates(json_parsed)
	  
			format_addr = json_parsed['results'][0]['formatted_address']
			lat = json_parsed['results'][0]['geometry']['location']['lat']
			lng = json_parsed['results'][0]['geometry']['location']['lng']
			"Suggested Address : #{format_addr}, Coordinates: #{lat}, #{lng}"
	end


	get '/' do 
		redirect '/login'
	end
	
	get '/login' do
		erb :login 
	end
	
	
	post '/login' do
	  
		authenticated = authenticate(params[:username], params[:password])
		
		if authenticated
			redirect '/location'
		else
			redirect '/login'
		end
	end

	  
	get '/location' do
		erb :location
	end
  
  
	post '/coordinates' do
		obj = geocode(params[:address].chomp)
		display_msg(obj)
	end
  
	run!
end

#App.run!





