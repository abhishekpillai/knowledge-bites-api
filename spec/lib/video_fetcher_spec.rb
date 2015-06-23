require 'rails_helper'
require 'video_fetcher'

describe VideoFetcher do
  describe '#run' do
    def stub_google_api_client
      client = double(Google::APIClient)
      allow(Google::APIClient).to receive(:new).and_return(client)

      list_method = double('Google::APIClient::Method')
      search_resource = double('Google::APIClient::Resource', list: list_method)
      youtube_api = double(Google::APIClient::API, search: search_resource)

      allow(client).to receive(:discovered_api).with('youtube', 'v3').
        and_return(youtube_api)

      client
    end

    context 'when service calls are successful' do
      before do
        @client = stub_google_api_client
      end

      def mock_video_in_response(title, video_id)
        snippet = double(
          'Google::APIClient::Schema::Youtube::V3::SearchResultSnippet',
          title: title
        )
        id_resource = double(
          'Google::APIClient::Schema::Youtube::V3::ResourceId',
          video_id: video_id
        )
        search_result = double(
          'Google::APIClient::Schema::Youtube::V3::SearchResult',
          id: id_resource,
          snippet: snippet
        )
      end

      def mock_google_api_response(num_videos)
        items = []
        num_videos.times do |i|
          items << mock_video_in_response("Video #{i}", "video_id_#{i}")
        end
        search_list_response = double(
          'Google::APIClient::Schema::Youtube::V3::SearchListResponse',
          items: items
        )
        double(Google::APIClient::Result, {
          data: search_list_response,
          success?: true,
          next_page: nil
        })
      end

      it 'populates the videos table with num of records requested' do
        expected_video_count = 10
        videos = mock_google_api_response(expected_video_count)
        expect(@client).to receive(:execute!).and_return(videos)

        VideoFetcher.run(expected_video_count)

        expect(Video.count).to eq(expected_video_count)
      end
    end

    context 'when service calls fail' do
      before do
        @client = stub_google_api_client
      end

      it 'does not create videos' do
        allow(@client).to receive(:execute!).
          and_raise(Google::APIClient::TransmissionError)

        expect { VideoFetcher.run(10) }.to_not change { Video.count }
      end
    end
  end
end
