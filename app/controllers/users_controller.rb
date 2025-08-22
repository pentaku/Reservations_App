class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
  end

  def show
    @user = User.find(params[:id])
  end

  def account
    @user = current_user
  end

  def profile
    @user = current_user
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
      flash[:success] = "新規作成しました"
      redirect_to users_profile_path #Get "/users/#{@user.id}"
    else
      render 'new'
    end
  end

  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
  end

  #PATCH /users/:id
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "プロフィールを編集しました！"
      redirect_to users_profile_path
    else
      render 'edit'
    end
  end

  def destroy
  end

  # パスワード更新フォームの表示
  def edit_password
    # パスワード更新フォームを表示
    @user = User.find(params[:id])
  end

  # パスワードの更新
  def update_password
    @user = User.find(params[:id])
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit_password'
    elsif @user.update(user_password_params)
      log_in @user
      flash[:success] = "パスワードが更新されました"
      redirect_to users_account_path
    else
      render 'edit_password'
    end
  end


  # =============================================================
  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                :password_confirmation,:image, :introduction)
  end

  def user_password_params
    params.require(:user).permit(:email,:current_password, :password, :password_confirmation)
  end

  # beforeアクション

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      store_location #どこかのページに遷移したい。セッション切れていた時に行きたいところを覚えておく
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    # ログインしていないと、current_userが呼び出せない。
    redirect_to(root_url) unless current_user?(@user)
  end

end