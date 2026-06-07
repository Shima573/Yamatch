require 'rails_helper'

RSpec.describe ActivityRecord, type: :model do
  describe 'カスタムバリデーションのテスト' do
    it '登山日に未来の日付を選択した場合、保存できずにエラーになること' do
      # 1. 登山日を「明日（未来）」にしてデータを仮作成する
      activity_record = build(:activity_record, climbed_at: 1.day.from_now)

      # 2. バリデーションを実行した結果、無効（false）であることを期待する
      expect(activity_record.valid?).to be_falsey
      # 3. エラーメッセージが正しく仕込まれているか確認する
      expect(activity_record.errors[:climbed_at]).to include("は未来の日付を選択できません")
    end

    it '画像が4枚以上の場合、保存できずにエラーになること' do
      # 1. まずは通常の登山記録を仮作成する
      activity_record = build(:activity_record)

      # 2. 4枚のダミー画像（Photo）を一気に詰め込む
      4.times { activity_record.photos.build }

      # 3. バリデーションを実行した結果、無効（false）であることを期待する
      expect(activity_record.valid?).to be_falsey
      # 4. エラーメッセージが正しく仕込まれているか確認する
      expect(activity_record.errors[:base]).to include("画像は3枚までです")
    end
  end
end
