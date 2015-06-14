require 'rails_helper'
require 'youtube/api_client'

module Youtube
  describe APIClient do
    describe '#search' do
      it 'returns nil if query is not String' do
        non_string_value = 1
        expect(APIClient.search(non_string_value)).to be_nil
      end

      context 'service call is successful' do
        def mock_response_from_youtube(video_id, title)
          {
            'id' => {'videoId' => video_id },
            'snippet' => { 'title' => title }
          }
        end

        it 'returns an array of Videos' do
          video_id = 'video1'
          video_title = 'Video 1'
          items = [mock_response_from_youtube(video_id, video_title)]
          response = double(Net::HTTPOK, body: { 'items' => items }.to_json)
          allow(Net::HTTP).to receive(:get_response).and_return(response)

          results = APIClient.search('anything')

          expect(results).to be_a(Array)
          video = results.first
          expect(video.title).to eq(video_title)
          expect(video.video_id).to eq(video_id)
        end

        it 'returns 4 results when num results is not specified' do
          default_max_results = 4

          items = []
          default_max_results.times do |index|
            video_id = "video id #{index}"
            video_title = "video title #{index}"
            items << mock_response_from_youtube(video_id, video_title)
          end
          response = double(Net::HTTPOK, body: { 'items' => items }.to_json)
          allow(Net::HTTP).to receive(:get_response).and_return(response)

          results = APIClient.search('anything')

          expect(results.count).to eq(default_max_results)
        end
      end
    end
  end
end
