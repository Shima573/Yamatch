FactoryBot.define do
  factory :activity_record do
    # ⬇︎ データベースの防波堤（null: false）を突破するための必須セット
    title { "楽しかった登山記録" }
    body { "山頂からの景色が最高でした！" }
    climbed_at { Time.current } # 未来の日付を禁止するバリデーションを回避するため「今」を設定

    # ⬇︎ 関連するモデルのテストデータも自動で作成して紐づける
    association :user
    association :mountain
  end
end
