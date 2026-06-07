require 'rails_helper'

RSpec.describe Mountain, type: :model do
  it 'データを保存したとき、体力度の正規化スコアが10倍になって自動計算されること' do
    # 1. 生の体力度を「5」にして山データを保存する
    mountain = create(:mountain, raw_physical_grade: 5)

    # 2. 自動計算の結果、正規化スコアが「50」になっていることを期待する
    expect(mountain.normalized_physical_score).to eq 50
  end

  it 'データを保存したとき、技術度の生データ（A）が数値スコア（1）に自動変換されること' do
    # 1. 生の技術度を「:A」にして山データを保存する
    mountain = create(:mountain, raw_technical_grade: :A)

    # 2. 自動計算の結果、技術度スコアが「1」になっていることを期待する
    expect(mountain.normalized_technical_score).to eq 1
  end
end
