module V1
  class BitesController < ApplicationController
    def index
      render json: { bites: Bite.first(4) }
    end
  end
end
