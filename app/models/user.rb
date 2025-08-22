class User < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_many :rooms, dependent: :destroy #Userが消えたら登録した部屋が消える。
  # 1番新しい部屋登録をfirstで取得する。順序が変わり、一番上に新しい部屋登録がくる。
  default_scope -> { order(created_at: :desc) }
  has_one_attached :image

  # 大文字と小文字の区別を無くす。（E-mailを小文字に直してからバリデーションをかける）
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 30 } #ユーザー名は必須、30文字以内

  #E-mail
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  #パスワード、has_secure_passwordにはデフォルトで長さとかが入っていない。
  has_secure_password

  # 編集時にパスワードは空でも良い。
  # パスワードが存在するときに限って、passwordが空でも編集可能。
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # ユーザーモデルに記載する方がユーザー観点の方が記述しやすい。
  # 自分の作成した部屋を全て抽出する。
  def my_room
    Room.where("user_id = ?", id)
  end

end
