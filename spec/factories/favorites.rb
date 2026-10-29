FactoryBot.define do
  factory :favorite do
    association :user
    association :mountain
  end
end
