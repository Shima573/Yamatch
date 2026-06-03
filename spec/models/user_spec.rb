require 'rails_helper'

RSpec.describe User, type: :model do
  it 'ファクトリが有効であること' do
    user = build(:user)
    expect(user).to be_valid
  end

  it '名前がない場合は無効であること' do
    user = build(:user, name: nil)
    expect(user).not_to be_valid
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

  it 'パスワードが5文字以下の場合は無効であること' do
    # パスワードと確認用パスワードの両方を、わざと5文字（短すぎる）にして上書き
    user = build(:user, password: '12345', password_confirmation: '12345')
    expect(user).not_to be_valid
  end
end
