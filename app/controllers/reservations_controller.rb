class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:edit, :update, :destroy]

  def index
    @reservations = current_user.reservations.includes(:room)
  end

  # 確認ページ
  def show
  end

  def create
    @reservation = current_user.reservations.new(reservation_params)
    if @reservation.save
      redirect_to reservations_path, notice: "予約が完了しました。"
    else
      render :confirm, status: :unprocessable_entity
    end
  end


  def confirm
    if params[:id].present?
      # 編集時（既存レコードを更新する形で確認）
      @reservation = current_user.reservations.find(params[:id])
      @reservation.assign_attributes(reservation_params)
    else
      # 新規予約時
      @reservation = current_user.reservations.new(reservation_params)
    end

    @room = @reservation.room

    # 先にバリデーション
    unless @reservation.valid?
      flash.now[:danger] = "予約情報を入力してください"
      render(params[:id].present? ? :edit : "rooms/show", status: :unprocessable_entity) and return
    end

    # バリデーション通ったあとに計算
    @nights = (@reservation.check_out - @reservation.check_in).to_i
    @total_price = @room.price * @nights * @reservation.guests
  end

  def edit
    @room = @reservation.room
  end

  # ここが確定ボタンのPOST先
  def update
    if @reservation.update(reservation_params)
      redirect_to reservations_path, notice: "予約が更新されました"
    else
      flash.now[:alert] = @reservation.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reservation.destroy
    flash[:success] = "予約を削除しました！"
    # リクエスト送ったページにリダイレクトする。
    redirect_to request.referrer || root_url
  end


  private

  def set_reservation
    @reservation = current_user.reservations.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:check_in, :check_out, :guests, :room_id)
  end
end
