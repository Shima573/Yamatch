require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    # 名前・メールアドレス・パスワード
    it 'ファクトリが有効であること' do
      user = build(:user)
      expect(user).to be_valid
    end

    it '名前がない場合は無効であること' do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
    end

    it '名前が50文字の場合は有効であること' do
      user = build(:user, name: 'a' * 50)
      expect(user).to be_valid
    end
    it '名前が51文字以上の場合は無効であること' do
      user = build(:user, name: 'a' * 51)
      expect(user).not_to be_valid
    end

    it 'メールアドレスがない場合は無効であること' do
      user = build(:user, email: nil) # メールアドレスをわざと空にする
      expect(user).not_to be_valid
    end

    it 'すでに登録されているメールアドレスの場合は無効であること' do
      # 1. まず、基準となる1人目のユーザーを「実際にデータベースに保存（create）」する
      create(:user, email: 'test@example.com')

      # 2. 次に、まったく同じメールアドレスを持った2人目のデータを「仮作成（build）」する
      duplicate_user = build(:user, email: 'test@example.com')

      # 3. 2人目はエラー（無効）になることを期待する
      expect(duplicate_user).not_to be_valid
    end

    it 'メールアドレスの大文字・小文字が異なっていても重複する場合は無効であること' do
      create(:user, email: 'test@example.com')
      duplicate_user = build(:user, email: 'TEST@example.com')
      expect(duplicate_user).not_to be_valid
    end

    it 'パスワードが5文字以下の場合は無効であること' do
      # パスワードと確認用パスワードの両方を、わざと5文字（短すぎる）にして上書き
      user = build(:user, password: '12345', password_confirmation: '12345')
      expect(user).not_to be_valid
    end

    it 'パスワードが6文字の場合は有効であること' do
      user = build(:user, password: '123456', password_confirmation: '123456')
      expect(user).to be_valid
    end

    it 'パスワードと確認用パスワードが一致しない場合は無効であること' do
      user = build(
        :user,
        password: '123456',
        password_confirmation: 'abcdef'
      )
      expect(user).not_to be_valid
    end
  end

  describe '.from_omniauth' do
    # Google認証
    it 'Googleのメールアドレスが未認証の場合はnilを返すこと' do
      auth = OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: '12345',
        info: {
          email: 'test@example.com',
          name: 'テストユーザー',
          email_verified: false
        }
      )

      expect(User.from_omniauth(auth)).to be_nil
    end

    it 'メールアドレスが存在しない場合はnilを返すこと' do
      auth = OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: '12345',
        info: {
          email: nil,
          name: 'テストユーザー',
          email_verified: true
        }
      )

      expect(User.from_omniauth(auth)).to be_nil
    end

    it 'すでにGoogle認証で登録済みのユーザーがいた場合、既存のユーザーを返す' do
      existing_user = create(
        :user,
        provider: 'google_oauth2',
        uid: '12345',
        email: 'test@example.com'
      )

      auth = OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: '12345',
        info: {
          email: 'test@example.com',
          name: 'テストユーザー',
          email_verified: true
        }
      )
      expect(User.from_omniauth(auth)).to eq(existing_user)
    end

    it '同じメールアドレスの通常ユーザーが存在する場合はnilを返すこと' do
      create(:user, email: 'test@example.com')

      auth = OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: '12345',
        info: {
          email: 'test@example.com',
          name: 'テストユーザー',
          email_verified: true
        }
      )

      expect(User.from_omniauth(auth)).to be_nil
    end

    it '初回Googleログイン時に新しいユーザーが作成されること' do
      auth = OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: '12345',
        info: {
          email: 'test@example.com',
          name: 'テストユーザー',
          email_verified: true
        }
      )

      expect {
        User.from_omniauth(auth)
      }.to change(User, :count).by(1)

      user = User.find_by(provider: 'google_oauth2', uid: '12345')

      expect(user.email).to eq('test@example.com')
      expect(user.name).to eq('テストユーザー')
    end
  end

  describe '#password_required?' do
    it '通常ユーザーの場合はパスワードが必要であること' do
      user = build(:user)

      expect(user.password_required?).to be true
    end

    it 'Google認証ユーザーの場合はパスワードが不要であること' do
      user = build(:user, provider: 'google_oauth2')

      expect(user.password_required?).to be false
    end
  end

  describe '#password_changeable?' do
    it 'Google認証ユーザーの場合はパスワード変更ができないこと' do
      user = build(:user, provider: 'google_oauth2')

      expect(user.password_changeable?).to be false
    end

    it '通常ユーザーの場合はパスワード変更ができること' do
      user = build(:user)

      expect(user.password_changeable?).to be true
    end
  end

  describe '#favorite' do
    # お気に入り登録
    it '山をお気に入り登録できること' do
      user = create(:user)
      mountain = create(:mountain)

      expect {
        user.favorite(mountain)
      }.to change(Favorite, :count).by(1)
    end
  end

  describe '#unfavorite' do
    # お気に入り解除
    it 'お気に入り登録した山を解除できること' do
      user = create(:user)
      mountain = create(:mountain)

      # お気に入りを1件登録
      user.favorite(mountain)

      expect {
        user.unfavorite(mountain)
      }.to change(Favorite, :count).by(-1)
    end
  end

  describe '#favorited?' do
    # お気に入り状態の確認
    it 'お気に入り登録されている場合はtrueを返すこと' do
      user = create(:user)
      mountain = create(:mountain)

      user.favorite(mountain)
      expect(user.favorited?(mountain)).to be true
    end
    it 'お気に入り登録されていない場合はfalseを返すこと' do
      user = create(:user)
      mountain = create(:mountain)

      expect(user.favorited?(mountain)).to be false
    end
  end

  describe 'アバター画像のバリデーション' do
    it 'PDFファイルの場合は無効であること' do
      user = build(:user)

      user.avatar.attach(
        io: StringIO.new('dummy pdf content'),
        filename: 'test.pdf',
        content_type: 'application/pdf'
      )
      expect(user).not_to be_valid
    end

    it 'PNG画像の場合は有効であること' do
      user = build(:user)

      user.avatar.attach(
        io: StringIO.new('dummy image content'),
        filename: 'test.png',
        content_type: 'image/png'
      )

      expect(user).to be_valid
    end

    it 'ファイルサイズが5MBの時は有効であること' do
      user = build(:user)

      user.avatar.attach(
        io: StringIO.new('a' * 5.megabytes),
        filename: 'test.png',
        content_type: 'image/png'
      )

      expect(user).to be_valid
    end

    it 'ファイルサイズが5MBをわずかに超えただけでも無効であること' do
      user = build(:user)

      user.avatar.attach(
        io: StringIO.new('a' * (5.megabytes + 1)),
        filename: 'test.png',
        content_type: 'image/png'
      )

      expect(user).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'ユーザーを削除するとお気に入りも削除されること' do
      user = create(:user)
      mountain = create(:mountain)

      user.favorite(mountain)

      expect {
        user.destroy
      }.to change(Favorite, :count).by(-1)
    end

    it 'ユーザーを削除すると診断結果も削除されること' do
      user = create(:user)
      create(:diagnosis, user: user)

      expect {
        user.destroy
      }.to change(Diagnosis, :count).by(-1)
    end

    it 'ユーザーを削除すると登山記録も削除されること' do
      user = create(:user)
      mountain = create(:mountain)

      create(:activity_record, user: user, mountain: mountain)

      expect {
        user.destroy
      }.to change(ActivityRecord, :count).by(-1)
    end

    it 'ユーザーを削除すると登山プランも削除されること' do
      user = create(:user)
      mountain = create(:mountain)

      create(:plan, user: user, mountain: mountain)

      expect {
        user.destroy
      }.to change(Plan, :count).by(-1)
    end
  end
end
