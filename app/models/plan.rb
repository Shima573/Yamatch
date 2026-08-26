class Plan < ApplicationRecord
  belongs_to :user
  belongs_to :mountain
  has_one :activity_record

  validates :title, length: { maximum: 50 }
  validates :climbing_date, presence: true
  validate :climbing_date_cannot_be_in_past
  validates :companion_count, numericality: { minimum: 1 }
  validates :route, length: { maximum: 300 }
  validates :note, length: { maximum: 500 }

  def climbing_date_cannot_be_in_past
    if climbing_date.present? && climbing_date < Date.current
      errors.add(:climbing_date, "は過去の日付を選択できません")
    end
  end
end
