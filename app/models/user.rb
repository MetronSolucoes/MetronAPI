require 'encryption'

class User < ApplicationRecord

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  belongs_to :company, optional: true

  validates :name, :email, :password, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :email, format: /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}\z/

  include UserQuery

  TOKEN_KEY = '50146e2f63e9047867457113534c558b'.freeze

  def self.find_by_token(token)
    return if token.blank?

    id = Encryption.decrypt(token, TOKEN_KEY)
    find(id)
  end

  def token
    return if id.blank?

    Encryption.crypt(id.to_s, TOKEN_KEY)
  end
end
