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

    it 'returns at most 4 bites of content on successful response' do
      5.times { Bite.create! }
      get '/v1/bites'
      bites = JSON.parse(response.body)['bites']
      expect(bites.count).to eq(4)
    end
  end
end
