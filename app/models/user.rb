class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  # 名前を必須にし、50文字以内にする
  validates :name, presence: true, length: { maximum: 50 }

  # 診断結果との関連付け（1対多）
  has_many :diagnoses, dependent: :destroy
end
