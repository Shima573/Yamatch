FactoryBot.define do
  factory :diagnosis do
    # データベースの null: false を突破するための設定
    association :user        # 自動的にUserモデルのテストデータを作成して紐づける
    total_score { 15 }       # とりあえずのデフォルト値をセット
    recommended_physical_min { 1 }
    recommended_physical_max { 5 }
    recommended_technical_max { 2 }
  end
end
