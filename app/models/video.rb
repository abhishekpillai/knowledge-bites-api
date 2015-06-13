class Video < ActiveRecord::Base
  has_many :bites, as: :content
end
