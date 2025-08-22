class Reservation < ApplicationRecord
  # 予約は必ず 1人のユーザー と 1つの部屋 に紐づく
  belongs_to :user
  belongs_to :room

  validates :check_in, :check_out, :guests, presence: true #空でないことを保証
  validates :guests, numericality: { greater_than_or_equal_to: 1 } #1以上
  validate :check_in_must_be_future #独自ルール をチェック
  validate :check_out_after_check_in #独自ルール をチェック

  # チェックアウト日 − チェックイン日 で宿泊日数を計算
  def nights
    (check_out - check_in).to_i
  end

  # 予約の 総支払い額 を自動計算
  def total_price
    room.price * nights * guests
  end

  private

  # チェックイン日は 今日以降の日付でなければならない
  def check_in_must_be_future
    if check_in.present? && check_in < Date.today
      errors.add(:check_in, "は本日以降の日付を選択してください")
    end
  end

  # チェックアウト日は チェックイン日より後 でなければならない
  def check_out_after_check_in
    if check_in.present? && check_out.present? && check_out <= check_in
      errors.add(:check_out, "はチェックイン日より後の日付にしてください")
    end
  end
end
