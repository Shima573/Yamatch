class Photo < ApplicationRecord
  belongs_to :activity_record

  has_one_attached :image

  validates :image, presence: true
  validate :image_type
  validate :image_size

  # アップロード前のチェック
  def image_type
    return unless image.attached?

    unless image.content_type.in?(%w[image/jpeg image/png image/gif image/webp])
      errors.add(:image, "形式が不正です")
    end
  end

  def image_size
    return unless image.attached?

    if image.blob.byte_size > 5.megabytes
      errors.add(:image, "サイズは5MB以下にしてください")
    end
  end
end
