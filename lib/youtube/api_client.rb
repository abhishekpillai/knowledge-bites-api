module Youtube
  class APIClient
    BASE_URL = 'https://www.googleapis.com/youtube/v3'
    API_KEY = ENV['YOUTUBE_API_KEY']
    SEARCH_URL = "#{BASE_URL}/search"

    def self.search(query, num_results_requested=4)
      raise ArgumentError.new('query must be a String') unless query.is_a?(String)
      max_results_allowed_per_request = 50 # this is limit placed by Google's API
      get_next_page = false
      next_page_token ||= nil
      results = []
      until num_results_requested == 0
        max_results_param =
          if num_results_requested > max_results_allowed_per_request
            get_next_page = true
            max_results_allowed_per_request
          else
            num_results_requested
          end

        params = {
          part: 'snippet',
          order: 'viewCount',
          type: 'video',
          q: query,
          maxResults: max_results_param,
          key: API_KEY
        }

        params.merge!(pageToken: next_page_token) if next_page_token

        uri = URI(SEARCH_URL)
        uri.query = URI.encode_www_form(params)
        response = Net::HTTP.get_response(uri)

        unless response.is_a?(Net::HTTPSuccess)
          log(:error, code: response.code, status: "failed")
          return nil
        end

        body = JSON.parse(response.body)
        videos = body['items']
        log(:info, code: response.code, status: "success", found: videos.count)

        next_page_token = body['nextPageToken'] if get_next_page

        videos.each do |item|
          video_id = item['id']['videoId']
          title = item['snippet']['title']
          results << Video.new(title: title, video_id: video_id)
        end

        num_results_requested =
          if body['pageInfo']['totalResults'] <= max_results_param
            0
          else
            num_results_requested - videos.count
          end
      end
      results
    end


    private

    def self.log(level, data)
      Rails.logger.send(level, data)
    end
    private_class_method :log
  end
end
