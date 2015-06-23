require 'google/api_client'

class VideoFetcher
  DEVELOPER_KEY = ENV['YOUTUBE_API_KEY']
  TOPIC = 'ruby lightning talks'
  MAX_RESULT_LIMIT = 50

  def self.run(count_of_videos)
    @client = Google::APIClient.new(
      :key => DEVELOPER_KEY,
      :authorization => nil,
      :application_name => 'Knowledge Bites application',
      :application_version => '0.0.1'
    )
    @youtube = @client.discovered_api('youtube', 'v3')

    begin
      search_response = get_videos(count_of_videos)

      videos = []

      search_response.each do |search_result|
        videos << Video.create!(
          title: search_result.snippet.title,
          video_id: search_result.id.video_id
        )
      end

    # for errors, according to google api docs
    rescue Google::APIClient::TransmissionError => e
      #puts e.result.body
    end
  end


  private

  def self.get_videos(count)
    videos = []
    request = {
      :api_method => @youtube.search.list,
      :parameters => {
        :part => 'snippet',
        :type => 'video',
        :order => 'viewCount',
        :q => TOPIC,
        :maxResults => MAX_RESULT_LIMIT
      }
    }
    until videos.count == count
      result = @client.execute!(request)
      break unless result && result.success?
      videos << result.data.items
      videos.flatten!
      request = result.next_page
      break unless request
    end
    videos
  end
  private_class_method :get_videos
end
