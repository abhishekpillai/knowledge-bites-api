require 'youtube/api_client'

class VideoFetcher
  def self.run(count_of_videos)
    videos = Youtube::APIClient.search('ruby lightning talks', count_of_videos)
    videos.each { |vid| vid.save!; Bite.create!(content: vid) }
  end
end
