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

  describe 'titleのバリデーション' do
    it 'タイトルが未入力の場合は無効になること' do
      activity_record = build(:activity_record, title: nil)

      # ① 無効であることを確認する
      expect(activity_record).not_to be_valid

      # ② titleのエラーメッセージを確認する
      expect(activity_record.errors[:title]).to include("を入力してください")
    end
  end

  describe 'bodyのバリデーション' do
    it '本文が500文字の場合は有効になること' do
      activity_record = build(:activity_record, body: "あ" * 500)

      expect(activity_record).to be_valid
    end

    it '本文が501文字の場合は無効になること' do
      activity_record = build(:activity_record, body: "あ" * 501)

      # ① 無効であることを確認する
      expect(activity_record).not_to be_valid
      # ② bodyのエラーメッセージを確認する
      expect(activity_record.errors[:body]).to include("は500文字以内で入力してください")
    end
  end

  describe 'climbed_atのバリデーション' do
    it '登山日が未入力の場合は無効になること' do
      activity_record = build(:activity_record, climbed_at: nil)

      # ① 無効であることを確認する
      expect(activity_record).not_to be_valid

      # ② climbed_atのエラーメッセージを確認する
      # puts activity_record.errors.full_messages
      expect(activity_record.errors[:climbed_at]).to include("を入力してください")
    end

    it '登山日が過去の場合は有効になること' do
      activity_record = build(:activity_record, climbed_at: 1.day.ago)

      expect(activity_record).to be_valid
    end

    it '登山日が今日の場合は有効になること' do
      activity_record = build(:activity_record, climbed_at: Time.current.beginning_of_day)

      expect(activity_record).to be_valid
    end
  end

  describe 'photos_limitのバリデーション' do
    it '画像が3枚の場合は有効になること' do
      activity_record = build(:activity_record)

      3.times do
        photo = activity_record.photos.build
        # ここでphotoに画像を添付する
        file = Rack::Test::UploadedFile.new(
          StringIO.new('a' * 5.megabytes),
          'image/png',
          original_filename: 'large_image.png'
        )
        photo.image.attach(file)
      end

      # ここにexpectを書く
      expect(activity_record.photos.length).to eq(3)
      expect(activity_record).to be_valid
    end

    it '画像が0枚の場合は有効になること' do
      activity_record = build(:activity_record)

      # ここにexpectを書く
      expect(activity_record.photos.length).to eq(0)
      expect(activity_record).to be_valid
    end


  end


end
