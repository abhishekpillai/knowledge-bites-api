module V1
  class BitesController < ApplicationController
    def index
      bites = Bite.first(4)
      return head 404 if bites.empty?
      presented_bites = bites.map do |bite|
        content = bite.content
        {
          title: content.title,
          url: content.url
        }
      end
      render json: { bites: presented_bites }
    end

    def main
      @bites = Bite.first(4)
    end
  end
end
