class HomesController < ApplicationController 
  before_action :authenticate_user!
  def index
    # return unless user_signed_in?
    redirect_to search_hotels_path
  end
end
