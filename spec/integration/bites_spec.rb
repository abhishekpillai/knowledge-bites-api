require 'rails_helper'

describe 'Bites' do
  describe 'GET /bites' do
    it 'returns status code of 200 on successful response' do
      get '/v1/bites'
      expect(response.response_code).to eq(200)
    end
  end
end
