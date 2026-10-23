require 'rails_helper'

RSpec.describe Mountain, type: :model do
  it 'データを保存したとき、体力度の正規化スコアが10倍になって自動計算されること' do
    # 1. 生の体力度を「5」にして山データを保存する
    mountain = create(:mountain, raw_physical_grade: 5)

    # 2. 自動計算の結果、正規化スコアが「50」になっていることを期待する
    expect(mountain.normalized_physical_score).to eq 50
  end
  it '体力度が最小値の1の場合、正規化スコアが10になること' do
    mountain = create(:mountain, raw_physical_grade: 1)

    expect(mountain.normalized_physical_score).to eq 10
  end
  it '体力度が最大値の10の場合、正規化スコアが100になること' do
    mountain = create(:mountain, raw_physical_grade: 10)

    expect(mountain.normalized_physical_score).to eq 100
  end

  it 'データを保存したとき、技術度の生データ（A）が数値スコア（1）に自動変換されること' do
    # 1. 生の技術度を「:A」にして山データを保存する
    mountain = create(:mountain, raw_technical_grade: :A)

    # 2. 自動計算の結果、技術度スコアが「1」になっていることを期待する
    expect(mountain.normalized_technical_score).to eq 1
  end
  it '技術度Eを保存すると、正規化スコアが5になる' do
    mountain = create(:mountain, raw_technical_grade: :E)

    expect(mountain.normalized_technical_score).to eq 5
  end


  describe '#recommendation_type' do
    it '山の体力度が診断結果と一致する場合はperfectを返すこと' do
      diagnosis = build(
        :diagnosis,
        recommended_physical_min: 4,
        recommended_physical_max: 6
      )

      mountain = create(:mountain, raw_physical_grade: 5)

      expect(mountain.recommendation_type(diagnosis)).to eq :perfect
    end
    it '山の体力度が診断結果と一致する場合はeasyを返すこと' do
      diagnosis = build(
        :diagnosis,
        recommended_physical_min: 3,
        recommended_physical_max: 5
      )

      mountain = create(:mountain, raw_physical_grade: 2)

      expect(mountain.recommendation_type(diagnosis)).to eq :easy
    end
    it '山の体力度と診断結果の差が15の場合はperfectを返すこと' do
      diagnosis = build(
        :diagnosis,
        recommended_physical_min: 4,
        recommended_physical_max: 5
      )

      mountain = create(:mountain, raw_physical_grade: 6)

      expect(mountain.recommendation_type(diagnosis)).to eq :perfect
    end
    it '山の体力度と診断結果の差が15を超えた場合はchallengeを返すこと' do
      diagnosis = build(
        :diagnosis,
        recommended_physical_min: 3,
        recommended_physical_max: 5
      )

      mountain = create(:mountain, raw_physical_grade: 6)

      expect(mountain.recommendation_type(diagnosis)).to eq :challenge
    end
    it '山の体力度と診断結果の差が-15の場合はperfectを返すこと' do
      diagnosis = build(
        :diagnosis,
        recommended_physical_min: 4,
        recommended_physical_max: 5
      )

      mountain = create(:mountain, raw_physical_grade: 3)

      expect(mountain.recommendation_type(diagnosis)).to eq :perfect
    end
  end

  describe '.recommend_for' do
    it '条件に合う山が1件の場合、その山を返すこと' do
      diagnosis = build(
        :diagnosis,
        recommended_physical_min: 4,
        recommended_physical_max: 6,
        recommended_technical_max: 2
      )

      mountain = create(
        :mountain,
        raw_physical_grade: 5,
        raw_technical_grade: :A
      )

      expect(Mountain.recommend_for(diagnosis)).to eq([mountain])
    end
  end

end
