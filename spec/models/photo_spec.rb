require 'rails_helper'

RSpec.describe Photo, type: :model do
  describe 'カスタムバリデーションのテスト' do
    it '5MBを超える画像をアップロードした場合、エラーになること' do
      photo = build(:photo)

      # 1. 6MB（5MB超）の擬似的なPNG画像ファイルを作成して添付する
      file = Rack::Test::UploadedFile.new(
        StringIO.new('a' * 6.megabytes),
        'image/png',
        original_filename: 'large_image.png'
      )
      photo.image.attach(file)

      # 2. バリデーションを実行して、弾かれることを検証する
      expect(photo.valid?).to be_falsey
      expect(photo.errors[:image]).to include("サイズは5MB以下にしてください")
    end

    it '対応していない形式（例: PDF）のファイルをアップロードした場合、エラーになること' do
      photo = build(:photo)

      # 1. PDF形式の擬似的なファイルを作成して添付する
      file = Rack::Test::UploadedFile.new(
        StringIO.new('dummy pdf content'),
        'application/pdf',
        original_filename: 'document.pdf'
      )
      photo.image.attach(file)

      # 2. バリデーションを実行して、弾かれることを検証する
      expect(photo.valid?).to be_falsey
      expect(photo.errors[:image]).to include("形式が不正です")
    end
  end
end
