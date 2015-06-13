require 'rails_helper'

describe 'Bites' do
  describe 'GET /bites' do
    context 'on success' do
      it 'returns response code of 200' do
        get '/v1/bites'

        expect(response.response_code).to eq(200)
      end

      it 'returns bites of content' do
        get '/v1/bites'

        body = JSON.parse(response.body)
        expect(body).to have_key('bites')
      end

      it 'returns at most 4 bites of content' do
        vid = Video.create! title: "Bobloblaw's Talk", url: 'http://youtube.com/her?'
        5.times { Bite.create! content: vid }

        get '/v1/bites'

        bites = JSON.parse(response.body)['bites']
        expect(bites.count).to eq(4)
      end

      it 'returns the expected info for each bite of content' do
        title = "Bobloblaw's Talk"
        url = 'http://youtube.com/her?'
        vid = Video.create! title: title, url: url
        Bite.create! content: vid

        get '/v1/bites'

        bite = JSON.parse(response.body)['bites'].first
        expect(bite.keys).to eq(['title', 'url'])
        expect(bite['title']).to eq(title)
        expect(bite['url']).to eq(url)
      end
    end
  end
end
