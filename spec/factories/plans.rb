FactoryBot.define do
  factory :plan do
    user { nil }
    mountain { nil }
    title { "MyString" }
    climbing_date { "2026-08-03" }
    companion_count { 1 }
    route { "MyText" }
    equipment { "MyText" }
    note { "MyText" }
    status { 1 }
  end
end
