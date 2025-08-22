class Room < ApplicationRecord
  belongs_to :user
  has_many :reservations, dependent: :destroy
  has_one_attached :image

  # 必須項目のバリデーション
  validates :user_id, presence: true
  validates :name, presence: true           # 施設名
  validates :description, presence: true  # 施設詳細
  # 料金が1円以上
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :address, presence: true        # 住所

  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                    size:         { less_than: 5.megabytes,
                                    message: "should be less than 5MB" }

# 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
