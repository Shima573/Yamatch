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

  end
end
