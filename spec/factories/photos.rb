FactoryBot.define do
  factory :photo do
    # 登山記録のテストデータも自動で作成して紐づける
    association :activity_record
  end
end
