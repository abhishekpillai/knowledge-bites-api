module Youtube
  class APIClient
    BASE_URL = 'https://www.googleapis.com/youtube/v3'
    API_KEY = ENV['YOUTUBE_API_KEY']
    SEARCH_URL = "#{BASE_URL}/search"

    def self.search(query, num_results=4)
      raise ArgumentError.new('query must be a String') unless query.is_a?(String)
      max_results_allowed_per_request = 50 # this is limit placed by Google's API
      results = []
      until num_results == 0
        next_page_token ||= nil
        max_results = if num_results > max_results_allowed_per_request
                        get_next_page = true
                        max_results_allowed_per_request
                      else
                        get_next_page = false
                        num_results
                      end

        params = {
          part: 'snippet',
          order: 'viewCount',
          type: 'video',
          q: query,
          maxResults: max_results,
          key: API_KEY
        }

        params.merge!(pageToken: next_page_token) if next_page_token

        uri = URI(SEARCH_URL)
        uri.query = URI.encode_www_form(params)
        response = Net::HTTP.get_response(uri)
        return nil unless response.is_a?(Net::HTTPSuccess)
        body = JSON.parse(response.body)
        next_page_token = body['nextPageToken'] if get_next_page
        body['items'].each do |item|
          video_id = item['id']['videoId']
          title = item['snippet']['title']
          results << Video.new(title: title, video_id: video_id)
        end
        num_results -= max_results
      end
      results
    end
  end
end
