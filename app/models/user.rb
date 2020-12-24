class User < ApplicationRecord
  
  attr_accessor :remember_token #リメンバートークンの仮想属性を作成する。
  before_save { self.email = email.downcase } #大文字を小文字にさせる。
  
  validates :name,  presence: true, length: { maximum: 50 } #存在性、50文字以内
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 }, #存在性、100文字以内
                    format: { with: VALID_EMAIL_REGEX }, #正規表現によるメールアドレスのフォーマット
                    uniqueness: true #一意の確認
  
  has_secure_password #パスワード用のコード
  validates :password, presence: true, length: { minimum: 6 } #存在性、最小6文字
  
  #渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost = 
    if ActiveModel::SecurePassword.min_cost
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
   BCrypt::Password.create(string, cost: cost)
  end 
  
  #ランダムなトークンを返します。
  def User.new_token
     SecureRandom.urlsafe_base64
  end
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def authenticated?(remember_token)
     return false if remember_digest.nil?
     BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
   #ユーザーのログイン情報を破棄します。
  def forget
    update_attribute(:remember_digest, nil)
  end 
end
