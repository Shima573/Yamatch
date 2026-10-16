FactoryBot.define do
  factory :plan do
    association :user
    association :mountain
    title { "MyString" }
    climbing_date { Date.current }
    companion_count { 1 }
    route { "MyText" }
    equipment { "MyText" }
    note { "MyText" }
    status { 1 }
  end
end
