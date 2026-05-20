class ActivityRecord < ApplicationRecord
  belongs_to :user
  belongs_to :mountain
  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos

  validates :title, presence: true
  validates :body, length: { maximum: 500 }
  validates :climbed_at, presence: true
  validate :climbed_at_cannot_be_in_future
  validate :photos_limit

  def climbed_at_cannot_be_in_future
    if climbed_at.present? && climbed_at > Time.current
      errors.add(:climbed_at, "は未来の日付を選択できません")
    end
  end

  def photos_limit
    if photos.length > 3
      errors.add(:base, "画像は3枚までです")
    end
  end
end
