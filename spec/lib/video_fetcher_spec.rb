require 'rails_helper'
require 'video_fetcher'

describe VideoFetcher do
  def generate_videos(num_videos)
    videos = []
    num_videos.times do |index|
      videos << Video.new(title: "Video #{index}", video_id: "video#{index}")
    end
    videos
  end

  it 'populates the videos table with num of records requested' do
    expected_video_count = 1000
    videos = generate_videos(expected_video_count)
    allow(Youtube::APIClient).to receive(:search).
      with("ruby lightning talks", expected_video_count).and_return(videos)

    VideoFetcher.run(expected_video_count)

    expect(Video.count).to eq(expected_video_count)
  end
end
