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

    it 'perfectが2件、easyが1件の場合は優先順位どおりに3件返すこと' do
      diagnosis = build(
        :diagnosis,
        recommended_physical_min: 4,
        recommended_physical_max: 6,
        recommended_technical_max: 2
      )

      perfect1 = create(:mountain, raw_physical_grade: 5, raw_technical_grade: :A)
      perfect2 = create(:mountain, raw_physical_grade: 4, raw_technical_grade: :B)
      easy = create(:mountain, raw_physical_grade: 3, raw_technical_grade: :A)

      expect(Mountain.recommend_for(diagnosis)).to eq([perfect2, perfect1, easy])
    end

    it '診断結果の技術度上限を超える山はおすすめに含まれないこと' do
      diagnosis = build(
        :diagnosis,
        recommended_physical_min: 4,
        recommended_physical_max: 6,
        recommended_technical_max: 2
      )

      mountain_a = create(:mountain, raw_physical_grade: 5, raw_technical_grade: :A)
      mountain_c = create(:mountain, raw_physical_grade: 5, raw_technical_grade: :C)

      expect(Mountain.recommend_for(diagnosis)).to eq([mountain_a])
    end

    it 'おすすめ候補が4件以上あっても、返す山は最大3件になること' do
      diagnosis = build(
        :diagnosis,
        recommended_physical_min: 4,
        recommended_physical_max: 6,
        recommended_technical_max: 2
      )
      create(:mountain, raw_physical_grade: 5, raw_technical_grade: :A)
      create(:mountain, raw_physical_grade: 4, raw_technical_grade: :B)
      create(:mountain, raw_physical_grade: 4, raw_technical_grade: :A)
      easy = create(:mountain, raw_physical_grade: 3, raw_technical_grade: :A)

      result = Mountain.recommend_for(diagnosis)

      # おすすめが3件であること
      expect(result.size).to eq(3)
      # 最初の2件がperfectであること、おすすめ結果の先頭2件が、どちらもperfectに分類されること
      expect(result.first(2)).to all(satisfy { |mountain|
        mountain.recommendation_type(diagnosis) == :perfect
      })
      # 最後の1件がeasyであること
      expect(result.last).to eq(easy)
    end

    it 'perfectとeasyが不足している場合はchallengeで補充すること' do
      diagnosis = build(
        :diagnosis,
        recommended_physical_min: 4,
        recommended_physical_max: 6,
        recommended_technical_max: 2
      )

      perfect1 = create(:mountain, raw_physical_grade: 5, raw_technical_grade: :A)
      challenge1 = create(:mountain, raw_physical_grade: 7, raw_technical_grade: :A)
      challenge2 = create(:mountain, raw_physical_grade: 8, raw_technical_grade: :B)

      expect(Mountain.recommend_for(diagnosis)).to eq([perfect1, challenge1, challenge2])
    end

    it 'perfectが複数ある場合は体力度が低い山を優先すること' do
      diagnosis = build(
        :diagnosis,
        recommended_physical_min: 4,
        recommended_physical_max: 6,
        recommended_technical_max: 2
      )

      mountain_high = create(:mountain, raw_physical_grade: 6, raw_technical_grade: :A)
      mountain_middle = create(:mountain, raw_physical_grade: 5, raw_technical_grade: :A)
      mountain_low = create(:mountain, raw_physical_grade: 4, raw_technical_grade: :A)

      expect(Mountain.recommend_for(diagnosis)).to eq([mountain_low, mountain_middle, mountain_high])
    end

    it 'easyが複数ある場合は体力度が高い山を優先すること' do
      diagnosis = build(
        :diagnosis,
        recommended_physical_min: 4,
        recommended_physical_max: 6,
        recommended_technical_max: 2
      )

      easy1 = create(:mountain, raw_physical_grade: 1, raw_technical_grade: :A)
      easy2 = create(:mountain, raw_physical_grade: 2, raw_technical_grade: :A)
      easy3 = create(:mountain, raw_physical_grade: 3, raw_technical_grade: :A)

      expect(Mountain.recommend_for(diagnosis)).to eq([easy3, easy2, easy1])
    end

    it '候補が20件を超えてもperfectの山をおすすめできること' do
      diagnosis = build(
        :diagnosis,
        recommended_physical_min: 4,
        recommended_physical_max: 6,
        recommended_technical_max: 2
      )

      20.times do
        create(:mountain, raw_physical_grade: 10, raw_technical_grade: :A)
      end

      perfect = create(:mountain, raw_physical_grade: 5, raw_technical_grade: :A)

      expect(Mountain.recommend_for(diagnosis)).to include(perfect)
    end

    it '条件に合う山が存在しない場合は空配列を返すこと' do
      diagnosis = build(
        :diagnosis,
        recommended_physical_min: 4,
        recommended_physical_max: 6,
        recommended_technical_max: 2
      )

      create(:mountain, raw_physical_grade: 5, raw_technical_grade: :C)

      expect(Mountain.recommend_for(diagnosis)).to eq([])
    end
  end

  describe '#distance_from' do
    it 'ユーザーの都道府県が未設定の場合はnilを返すこと' do
      user = build(:user, prefecture: nil)
      mountain = build(:mountain)

      expect(mountain.distance_from(user)).to be_nil
    end

    it 'ユーザーの都道府県が位置情報に登録されていない場合はnilを返すこと' do
      user = build(:user, prefecture: '存在しない都道府県')
      mountain = build(:mountain)

      expect(mountain.distance_from(user)).to be_nil
    end

    it 'ユーザーと山の座標が同じ場合は距離が0kmになること' do
      user = build(:user, prefecture: '東京都')

      location = Mountain::PREFECTURE_LOCATIONS['東京都']

      mountain = build(
        :mountain,
        latitude: location[:lat],
        longitude: location[:lng]
      )

      expect(mountain.distance_from(user)).to be_within(0.001).of(0)
    end

    it 'ユーザーと山の座標が異なる場合は正しい距離を返すこと' do
      user = build(:user, prefecture: '東京都')

      location = Mountain::PREFECTURE_LOCATIONS['東京都']

      mountain = build(
        :mountain,
        latitude: location[:lat] + 1,
        longitude: location[:lng]
      )

      expect(mountain.distance_from(user)).to be_within(1).of(111)
    end
  end

  describe '#prefecture_location' do
    it '登録されている都道府県の位置情報を返すこと' do
      mountain = build(:mountain)

      location = Mountain::PREFECTURE_LOCATIONS['東京都']

      expect(mountain.prefecture_location('東京都')).to eq(location)
    end

    it '登録されていない都道府県の場合はnilを返すこと' do
      mountain = build(:mountain)

      expect(mountain.prefecture_location('存在しない都道府県')).to be_nil
    end
  end

  describe '#technical_rank_score' do
    it '技術度がCの場合は3を返すこと' do
      mountain = build(:mountain, raw_technical_grade: :C)

      expect(mountain.technical_rank_score).to eq(3)
    end

    it '技術度がAの場合は1を返すこと' do
      mountain = build(:mountain, raw_technical_grade: :A)

      expect(mountain.technical_rank_score).to eq(1)
    end

    it '技術度がEの場合は5を返すこと' do
      mountain = build(:mountain, raw_technical_grade: :E)

      expect(mountain.technical_rank_score).to eq(5)
    end
  end

  describe 'before_save' do
    it '技術度を変更して保存すると正規化スコアも更新されること' do
      mountain = create(:mountain, raw_technical_grade: :A)

      mountain.update!(raw_technical_grade: :E)

      expect(mountain.reload.normalized_technical_score).to eq(5)
    end

    it '体力度を変更して保存すると正規化スコアも更新されること' do
      mountain = create(:mountain, raw_physical_grade: 3)

      mountain.update!(raw_physical_grade: 7)

      expect(mountain.reload.normalized_physical_score).to eq(70)
    end
  end

end
