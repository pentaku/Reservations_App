class RoomsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]


  def index
    @rooms, @total_count = search_rooms
  end

  def show
    @room = Room.find(params[:id])

    # 検索フォームを出したい場合
    @rooms, @total_count = search_rooms
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      flash[:success] = "作成しました !"
      redirect_to @room
    else
      render :new
    end
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    flash[:success] = "削除しました！"
    # リクエスト送ったページにリダイレクトする。
    redirect_to request.referrer || root_url
  end

  # 登録した施設一覧ページ
  def own
    @rooms = current_user.rooms # 現在のユーザーの部屋を取得
  end

  private
  def room_params
    params.require(:room).permit(:name, :description, :price, :address, :image)
  end

  def correct_user
    # カレントユーザーの部屋コレクションを取得して、検索をかける
    @room = current_user.rooms.find_by(id: params[:id])
    redirect_to(root_url) if @room.nil?
  end

end
