class StaticPagesController < ApplicationController
  def home
    # 初期値として全施設を取得
    @rooms = Room.all

    # エリア検索
    if params[:area].present?
      @rooms = @rooms.where("address LIKE ?", "%#{params[:area]}%")
    end

    # フリーワード検索（施設名・詳細）
    if params[:keyword].present?
      keyword = "%#{params[:keyword]}%"
      @rooms = @rooms.where("name LIKE ? OR description LIKE ?", keyword, keyword)
    end

    # 件数
    @total_count = @rooms.count
  end
end
