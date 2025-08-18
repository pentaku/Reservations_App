class ReservationsController < ApplicationController
  def index
  end

  # 確認ページ
  def show
  end


  def edit
  end

  def destroy
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
    @nights = (@reservation.check_out - @reservation.check_in).to_i
    @total_price = @room.price * @nights * @reservation.guests

    unless @reservation.valid?
      flash.now[:alert] = @reservation.errors.full_messages.join(", ")
      render(params[:id].present? ? :edit : "rooms/show", status: :unprocessable_entity)
    end
  end

  def create
    @reservation = current_user.reservations.new(reservation_params)
    if @reservation.save
      redirect_to reservations_path, notice: "予約が完了しました。"
    else
      render :confirm, status: :unprocessable_entity
    end
  end

  private
  def reservation_params
    params.require(:reservation).permit(:check_in, :check_out, :guests, :room_id)
  end
end
