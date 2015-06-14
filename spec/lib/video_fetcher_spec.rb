require 'video_fetcher'

describe VideoFetcher do
  def generate_videos(num_videos)
    videos = []
    num_videos.times do |index|
      videos << { title: "Video #{index}", url: "http://youtube.com/video#{index}" }
    end
    videos
  end

  it 'populates the videos table with records' do
    expected_video_count = 1000
    videos = generate_videos(expected_video_count)
    Youtube::APIClient.stub(:search).with("ruby lightning talks").and_return([videos])

    VideoFetcher.run

    expect(Video.count).to eq(expected_video_count)
  end
end
