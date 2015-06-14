require 'rails_helper'

describe 'Bites' do
  describe 'GET /bites' do
    context 'on success' do
      before do
        @vid = Video.create! title: "Bobloblaw's Talk", video_id: 'video1'
        Bite.create! content: @vid
      end

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
        5.times { Bite.create! content: @vid }

        get '/v1/bites'

        bites = JSON.parse(response.body)['bites']
        expect(bites.count).to eq(4)
      end

      it 'returns the expected info for each bite of content' do
        title = @vid.title
        video_id = @vid.video_id

        get '/v1/bites'

        bite = JSON.parse(response.body)['bites'].first
        expect(bite.keys).to eq(['title', 'videoId'])
        expect(bite['title']).to eq(title)
        expect(bite['videoId']).to eq(video_id)
      end
    end

    context 'on failure' do
      it 'returns a response code of 404 when no bites are found' do
        get '/v1/bites'

        expect(response.response_code).to eq(404)
      end
    end
  end
end
