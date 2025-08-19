class StaticPagesController < ApplicationController
  def home
    @rooms, @total_count = search_rooms
  end
end
