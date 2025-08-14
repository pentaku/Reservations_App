class RoomsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def index
    # @Rooms = Room.all
  end

  def show
  end

  def new
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      flash[:success] = "作成しました !"
      redirect_to @room #Get "/users/#{@user.id}"
    else
      render "new"
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  # 登録した施設一覧ページ
  # def own
  #   @rooms = current_user.rooms # 現在のユーザーの部屋を取得
  # end


  private
  def room_params
    params.require(:room).permit(:description, :price)
  end


end
