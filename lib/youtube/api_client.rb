module Youtube
  class APIClient
    BASE_URL = 'https://www.googleapis.com/youtube/v3'
    API_KEY = ENV['YOUTUBE_API_KEY']
    SEARCH_URL = "#{BASE_URL}/search"

    def self.search(query, num_results=4)
      raise ArgumentError.new('query must be a String') unless query.is_a?(String)
      uri = URI(SEARCH_URL)
      params = {
        part: 'snippet',
        order: 'viewCount',
        type: 'video',
        maxResults: num_results,
        q: query,
        key: API_KEY
      }
      uri.query = URI.encode_www_form(params)
      response = Net::HTTP.get_response(uri)
      JSON.parse(response.body)['items'].map do |item|
        video_id = item['id']['videoId']
        title = item['snippet']['title']
        Video.new(title: title, video_id: video_id)
      end
    end
  end
end
