require 'rails_helper'

RSpec.describe Diagnosis, type: :model do
  describe '.build_from_answers' do
    it 'すべての質問に5点（満点）と回答した場合、おすすめの体力最大値（recommended_physical_max）が10になること' do
      params = { q1: '5', q2: '5', q3: '5', q4: '5', q5: '5' }
      diagnosis = Diagnosis.build_from_answers(params)
      expect(diagnosis.recommended_physical_max).to eq 10
    end

    it "全問最低点の場合、recommended_physical_min が1になること" do
      params = { q1: '1', q2: '1', q3: '1', q4: '1', q5: '1' }
      diagnosis = Diagnosis.build_from_answers(params)

      expect(diagnosis.recommended_physical_min).to eq 1
    end

    it '技術質問の合計が2点の場合、おすすめの技術最大値（recommended_technical_max）が1になること' do
      params = { q1: '3', q2: '3', q3: '3', q4: '1', q5: '1' }
      diagnosis = Diagnosis.build_from_answers(params)
      expect(diagnosis.recommended_technical_max).to eq 1
    end

    it '技術質問の合計が4点の場合、おすすめの技術最大値（recommended_technical_max）が1になること' do
      params = { q1: '3', q2: '3', q3: '3', q4: '2', q5: '2' }
      diagnosis = Diagnosis.build_from_answers(params)
      expect(diagnosis.recommended_technical_max).to eq 1
    end

    it '技術質問の合計が5点の場合、おすすめの技術最大値（recommended_technical_max）が2になること' do
      params = { q1: '3', q2: '3', q3: '3', q4: '3', q5: '2' }
      diagnosis = Diagnosis.build_from_answers(params)
      expect(diagnosis.recommended_technical_max).to eq 2
    end

    it '技術質問の合計が7点の場合、おすすめの技術最大値（recommended_technical_max）が2になること' do
      params = { q1: '3', q2: '3', q3: '3', q4: '4', q5: '3' }
      diagnosis = Diagnosis.build_from_answers(params)
      expect(diagnosis.recommended_technical_max).to eq 2
    end

    it '技術質問の合計が8点の場合、おすすめの技術最大値（recommended_technical_max）が3になること' do
      params = { q1: '3', q2: '3', q3: '3', q4: '4', q5: '4' }
      diagnosis = Diagnosis.build_from_answers(params)
      expect(diagnosis.recommended_technical_max).to eq 3
    end

    it '技術質問の合計が9点の場合、おすすめの技術最大値（recommended_technical_max）が4になること' do
      params = { q1: '3', q2: '3', q3: '3', q4: '4', q5: '5' }
      diagnosis = Diagnosis.build_from_answers(params)
      expect(diagnosis.recommended_technical_max).to eq 4
    end

    it '技術質問の合計が10点の場合、おすすめの技術最大値（recommended_technical_max）が5になること' do
      params = { q1: '3', q2: '3', q3: '3', q4: '5', q5: '5' }
      diagnosis = Diagnosis.build_from_answers(params)
      expect(diagnosis.recommended_technical_max).to eq 5
    end

    it "5つの質問の合計点が11点になること" do
      params = { q1: '3', q2: '2', q3: '3', q4: '2', q5: '1' }
      diagnosis = Diagnosis.build_from_answers(params)
      expect(diagnosis.total_score).to eq 11
    end

  describe '#target_physical_score' do
    it "体力度の最小値が4、最大値が6の場合、スコアが50になること" do
      diagnosis = Diagnosis.new(
        recommended_physical_min: 4,
        recommended_physical_max: 6
      )
      expect(diagnosis.target_physical_score).to eq 50
    end
  end
  end
end
