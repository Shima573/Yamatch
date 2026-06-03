require 'rails_helper'

RSpec.describe User, type: :model do
  it 'ファクトリが有効であること' do
    user = build(:user)
    expect(user).to be_valid
  end
end
