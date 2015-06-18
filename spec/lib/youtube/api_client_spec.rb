require 'rails_helper'
require 'youtube/api_client'

module Youtube
  describe APIClient do
    describe '#search' do
      it 'raises error if query is not String' do
        non_string_value = 1
        expect{ APIClient.search(non_string_value) }.
          to raise_error(ArgumentError, 'query must be a String')
      end

      context 'service call is successful' do
        def mock_response_from_youtube(videos)
          items = []
          videos.each do |v|
            items << {
              'id' => {'videoId' => v[:video_id] },
              'snippet' => { 'title' => v[:title] }
            }
          end

          {
            'pageInfo' => { 'totalResults' => videos.count },
            'items' => items
          }
        end

        it 'returns an array of Videos' do
          video_id = 'video1'
          video_title = 'Video 1'
          response_body = mock_response_from_youtube([{video_id: video_id, title: video_title}])
          response = double(Net::HTTPSuccess, is_a?: true, body: response_body.to_json)
          allow(Net::HTTP).to receive(:get_response).and_return(response)

          results = APIClient.search('anything')

          expect(results).to be_a(Array)
          video = results.first
          expect(video.title).to eq(video_title)
          expect(video.video_id).to eq(video_id)
        end

        it 'returns 4 results when num results is not specified' do
          default_max_results = 4

          videos = (0...default_max_results).inject([]) do |h, index|
            h << { video_id: "video id #{index}", title: "video title #{index}" }
            h
          end
          response_body = mock_response_from_youtube(videos)
          response = double(Net::HTTPSuccess, is_a?: true, body: response_body.to_json)
          allow(Net::HTTP).to receive(:get_response).and_return(response)

          results = APIClient.search('anything')

          expect(results.count).to eq(default_max_results)
        end

        it 'makes multiple requests when more than 50 results are requested and found' do
          max_results_per_request = 50
          num_requested = max_results_per_request + 1
          video_id = 'video1'
          video_title = 'Video 1'
          videos = (0...num_requested).inject([]) do |h, index|
            h << { video_id: "video id #{index}", title: "video title #{index}" }
            h
          end
          response_body = mock_response_from_youtube(videos)

          expect(Net::HTTP).to receive(:get_response).twice.
            and_return(double(
              Net::HTTPSuccess,
              is_a?: true,
              body: response_body.to_json
            ))

          results = APIClient.search('anything', num_requested)
        end

        it 'returns only available results if num_results requested is greater than actual result set' do
          max_results_per_request = 50
          num_results = max_results_per_request + 1
          total_results_set = max_results_per_request

          expect(Net::HTTP).to receive(:get_response).once.
            and_return(double(
              Net::HTTPSuccess,
              is_a?: true,
              body: {
                'pageInfo' => { 'totalResults' => 50 },
                'items' => anything
              }.to_json
            ))

          results = APIClient.search('anything', num_results)
        end
      end

      context 'service call is unsuccesful' do
        it 'returns nil' do
          response = double("A Net::HTTP failed request class", is_a?: false)
          allow(Net::HTTP).to receive(:get_response).and_return(response)

          expect(APIClient.search('anything')).to be_nil
        end
      end
    end
  end
end
