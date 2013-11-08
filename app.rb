require 'sinatra/base'
require 'json'
require 'net/http'

# http://www.sinatrarb.com/
class App < Sinatra::Base
	use Rack::Auth::Basic, "Protected Area" do |username, password|
	  username == 'Busbud' && password == 'password123'
	end

	get '/suggestions' do
		@query = params[:q]

		uri = URI('http://maps.googleapis.com/maps/api/geocode/json')
		params = { :sensor => false, :address => @query }
		uri.query = URI.encode_www_form(params)

		res = Net::HTTP.get_response(uri)

		if res.is_a?(Net::HTTPSuccess)
			data = JSON.parse(res.body)["results"].map do |res|
				{
					name: res["formatted_address"],
					latitude: res["geometry"]["location"]["lat"],
					longitude: res["geometry"]["location"]["lng"]
				}
			end

			if data.empty?
				status 404
			end

			{results: data}.to_json
		else
			status 404
		end
	end
end
