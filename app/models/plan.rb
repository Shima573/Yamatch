class Plan < ApplicationRecord
  belongs_to :user
  belongs_to :mountain
  has_one :activity_records
end
