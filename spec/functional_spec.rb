require 'spec_helper'

describe 'GET /suggestions' do
  describe 'with invalid auth' do
    subject(:response) do
      basic_authorize 'Bob', 'Marley'
      get '/suggestions', {:q => 'Paris'}
    end

    it 'returns a 401' do
      expect(response.status).to eq(401)
    end
  end

  describe 'with valid auth' do
    subject(:response) do
      basic_authorize 'Busbud', 'password123'
      get '/suggestions', {:q => 'Paris'}
    end

    it 'returns a 200' do
      expect(response.status).to eq(200)
    end
  end

  describe 'with a non-existent city' do
    subject(:response) do
      basic_authorize 'Busbud', 'password123'
      get '/suggestions', {:q => 'SomeRandomCityInTheMiddleOfNowhere'}
    end

    it 'returns a 404' do
      expect(response.status).to eq(404)
    end

    it 'returns an empty array of results' do
      expect(response.json_body['results']).to be_a(Array)
      expect(response.json_body['results']).to have(0).items
    end
  end

  describe 'with a valid city' do
    subject(:response) do
      basic_authorize 'Busbud', 'password123'
      get '/suggestions', {:q => 'Montreal'}
    end

    it 'returns a 200' do
      expect(response.status).to eq(200)
    end

    it 'returns an array of results' do
      expect(response.json_body['results']).to be_a(Array)
      expect(response.json_body['results']).to_not be_empty
    end

    it 'contains a match' do
      names = response.json_body['results'].map { |r| r['name'] }
      expect(names.grep(/montreal/i)).to_not be_empty
    end

    it 'contains latitudes and longitudes' do
      response.json_body['results'].each do |result|
        expect(result['latitude']).to_not be_nil
        expect(result['longitude']).to_not be_nil
      end
    end
  end
end