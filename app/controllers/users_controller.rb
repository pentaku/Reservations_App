class UsersController < ApplicationController
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
    # @log_in @user ユーザー作成完了したら、ログインさせる。
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


  # =============================================================
  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                :password_confirmation)
  end

end
