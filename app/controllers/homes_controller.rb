class HomesController < ApplicationController
  def index
    return unless user_signed_in?

    redirect_to search_hotels_path
  end
end
