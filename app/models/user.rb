class User < ApplicationRecord

  # 大文字と小文字の区別を無くす。（E-mailを小文字に直してからバリデーションをかける）
  before_save { self.email = email.downcase }

  # ユーザー名
  validates :name, presence: true, length: { maximum: 30 } #ユーザー名は必須、30文字以内

  #E-mail
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  #パスワード、has_secure_passwordにはデフォルトで長さとかが入っていない。
  has_secure_password

  # 編集時にパスワードは空でも良い。ログイン時はだめ。
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
end
