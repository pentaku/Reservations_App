class ApplicationController < ActionController::Base
  include SessionsHelper

  private
  # ユーザーのログインを確認する
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def search_rooms
    rooms = Room.all
    total_count = rooms.count

    if params[:area].present? || params[:keyword].present?
      # --- エリア検索 ---
      if params[:area].present?
        case params[:area]
        when "東京"
          rooms = rooms.where("address LIKE ?", "%東京%")
        when "大阪"
          rooms = rooms.where("address LIKE ?", "%大阪%")
        when "京都"
          rooms = rooms.where("address LIKE ? AND address NOT LIKE ?", "%京都%", "%東京都%")
        when "札幌"
          rooms = rooms.where("address LIKE ?", "%札幌%")
        end
      end

      # --- フリーワード検索 ---
      if params[:keyword].present?
        keyword = "%#{params[:keyword]}%"
        rooms = rooms.where("name LIKE ? OR description LIKE ?", keyword, keyword)
      end

      total_count = rooms.count
    end

    [rooms, total_count]
  end
end
