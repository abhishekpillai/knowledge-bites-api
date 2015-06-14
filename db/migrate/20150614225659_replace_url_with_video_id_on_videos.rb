class ReplaceUrlWithVideoIdOnVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :url, :string
    add_column :videos, :video_id, :string
  end
end
