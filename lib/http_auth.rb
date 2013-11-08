module Sinatra
  module HTTPAuth

    def http_basic_authenticate_with(credentials)

      helpers do
        def authorized?(credentials)
          @auth ||=  Rack::Auth::Basic::Request.new(request.env)
          @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == credentials.values
        end
      end

      before do
        unless authorized?(credentials)
          response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
          throw(:halt, [401, "Not authorized\n"])
        end
      end

    end

  end
end