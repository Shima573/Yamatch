class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :mountain

  validates :user_id, uniqueness: { scope: :mountain_id }
end
