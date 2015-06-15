namespace :populate do
  "Populate video content"
  task :videos => :environment do
    require 'video_fetcher'
    VideoFetcher.run(50)
  end
end
