require 'rails_helper'

describe 'Bites' do
  describe 'GET /bites' do
    it 'returns response code of 200 on successful response' do
      get '/v1/bites'
      expect(response.response_code).to eq(200)
    end

    it 'returns bites of content on successful response' do
      get '/v1/bites'
      body = JSON.parse(response.body)
      expect(body).to have_key('bites')
    end
  end
end
