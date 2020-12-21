class User < ApplicationRecord
  before_save { self.email = email.downcase } #大文字を小文字にさせる。
  
  validates :name,  presence: true, length: { maximum: 50 } #存在性、50文字以内
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 }, #存在性、100文字以内
                    format: { with: VALID_EMAIL_REGEX }, #正規表現によるメールアドレスのフォーマット
                    uniqueness: true #一意の確認
  
  has_secure_password #パスワード用のコード
  validates :password, presence: true, length: { minimum: 6 } #存在性、最小6文字
end
