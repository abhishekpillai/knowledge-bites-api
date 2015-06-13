module V1
  class BitesController < ApplicationController
    def index
      bites = Bite.first(4)
      presented_bites = bites.map do |bite|
        content = bite.content
        {
          title: content.title,
          url: content.url
        }
      end
      render json: { bites: presented_bites }
    end
  end
end
