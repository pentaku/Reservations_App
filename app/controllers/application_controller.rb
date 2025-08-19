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
      # エリア検索（東京・大阪・京都・札幌に限定）
      if params[:area].present? && ["東京", "大阪", "京都", "札幌"].include?(params[:area])
        rooms = rooms.where("address LIKE ?", "%#{params[:area]}%")
      end

      # フリーワード検索（施設名・詳細）
      if params[:keyword].present?
        keyword = "%#{params[:keyword]}%"
        rooms = rooms.where("name LIKE ? OR description LIKE ?", keyword, keyword)
      end

      # 検索したときだけ件数カウント
      total_count = rooms.count
    end

    [rooms, total_count]
  end
end


