class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :requests, dependent: :destroy
  has_many :transactions
  has_many :prompts, dependent: :destroy
  has_one :wallet, dependent: :destroy
  after_create :assign_wallet

  private

  def assign_wallet
    Wallet.create(user: self)
  end
end
