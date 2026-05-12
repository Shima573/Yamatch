class Photo < ApplicationRecord
  belongs_to :activity_record

  has_one_attached :image

  validates :image, presence: true
  validate :image_type

  # アップロード前のチェック
  def image_type
    return unless image.present?

    unless image.content_type.in?(%w[image/jpeg image/png image/gif image/webp])
      errors.add(:image, "形式が不正です")
    end
  end

end
