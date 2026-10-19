require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'バリデーション' do
    it "タイトルが50文字の場合は有効である" do
      expect(FactoryBot.build(:plan, title: "a" * 50)).to be_valid
    end
    it "タイトルが51文字の場合は無効である" do
      # ① Planを生成する
      plan = FactoryBot.build(:plan, title: "a" * 51)
      # ② Validationを実行する
      plan.valid?
      # ③ titleのエラーメッセージを検証する
      expect(plan.errors[:title]).to include("は50文字以内で入力してください")
    end

    it "登山予定日が未入力の場合、Planが無効になる" do
      expect(FactoryBot.build(:plan, climbing_date: nil )).not_to be_valid
    end

    it "登山予定日が過去の場合は無効" do
      expect(FactoryBot.build(:plan, climbing_date: Date.current - 1)).not_to be_valid
    end

    it "登山予定日が今日の場合は有効である" do
      expect(FactoryBot.build(:plan)).to be_valid
    end

    it "同行人数が1人の場合は有効" do
      expect(FactoryBot.build(:plan, companion_count: 1)).to be_valid
    end
    it "同行人数が0人の場合は無効" do
      expect(FactoryBot.build(:plan, companion_count: 0)).not_to be_valid
    end
    it "同行人数が未入力の場合は無効" do
      expect(FactoryBot.build(:plan, companion_count: nil)).not_to be_valid
    end

    it "ルート内容が300文字の場合は有効である" do
      expect(FactoryBot.build(:plan, route: "b" * 300 )).to be_valid
    end
    it "ルート内容が301文字の場合は無効である" do
      plan = FactoryBot.build(:plan, route: "b" * 301 )
      plan.valid?
      expect(plan.errors[:route]).to include("は300文字以内で入力してください")
    end

    it "メモ内容が500文字の場合は有効である" do
      expect(FactoryBot.build(:plan, note: "c" * 500 )).to be_valid
    end
    it "メモ内容が501文字の場合は無効である" do
      plan = FactoryBot.build(:plan, note: "b" * 501 )
      plan.valid?
      expect(plan.errors[:note]).to include("は500文字以内で入力してください")
    end
  end
end
