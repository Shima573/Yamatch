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
end
