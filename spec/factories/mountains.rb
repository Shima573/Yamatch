FactoryBot.define do
  factory :mountain do
    name { "テスト対象の山" }
    raw_physical_grade { 5 }
    raw_technical_grade { :A }
  end
end
