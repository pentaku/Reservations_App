class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  # Post /users(+ params) => users#create
  # name,email,password,password_confirmation以外は受け付けない
  # マスアサイメント脆弱性で[:admin]とか送られると権限が書き換えられてしまう可能性。
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user #ユーザー作成完了したら、ログインさせる。
      flash[:success] = "Welcome !"
      redirect_to @user #Get "/users/#{@user.id}"
    else
      render 'new'
    end
  end

  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile update"
      redirect_to @user
    else
      render 'edit'
    end
  end


  # =============================================================
  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                :password_confirmation)
  end

  # beforeアクション

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

end