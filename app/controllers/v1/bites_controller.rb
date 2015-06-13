module V1
  class BitesController < ApplicationController
    def index
      render json: { bites: [] }
    end
  end
end
