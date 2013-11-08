ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require 'json'
require 'coveralls'

# Code coverage, see https://coveralls.io/docs/ruby
# Note: The Coveralls.wear! must occur before any of your application code is required,
# so should be at the very top of your spec_helper.rb, test_helper.rb, or env.rb, etc.
Coveralls.wear!

require_relative '../app'

# Add an #app method for Rack::Test
module TestHelpers
  def app
    App
  end
end

# Monkey patch to simplify parsing json responses
class Rack::MockResponse
  def json_body
    @json_body ||= JSON.load(body)
  end
end

# http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  config.expect_with(:rspec) { |c| c.syntax = :expect }

  config.include TestHelpers
  config.include Rack::Test::Methods
end