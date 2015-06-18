namespace :populate do
  desc "Populate video content"
  task :videos => :environment do
    require 'video_fetcher'
    VideoFetcher.run(200)
  end
end
