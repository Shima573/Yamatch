require 'rails_helper'

RSpec.describe Diagnosis, type: :model do
  describe '.build_from_answers' do
    it 'すべての質問に5点（満点）と回答した場合、おすすめの体力最大値（recommended_physical_max）が10になること' do
      params = { q1: '5', q2: '5', q3: '5', q4: '5', q5: '5' }
      diagnosis = Diagnosis.build_from_answers(params)
      expect(diagnosis.recommended_physical_max).to eq 10
    end

    # ⬇︎ここから新しく追加する境界線のテスト1
    it '技術質問の合計が7点の場合、おすすめの技術最大値（recommended_technical_max）が2になること' do
      # q4(4点) + q5(3点) = 7点
      params = { q1: '3', q2: '3', q3: '3', q4: '4', q5: '3' }
      diagnosis = Diagnosis.build_from_answers(params)
      expect(diagnosis.recommended_technical_max).to eq 2
    end

    # ⬇︎ここから新しく追加する境界線のテスト2
    it '技術質問の合計が8点の場合、おすすめの技術最大値（recommended_technical_max）が3になること' do
      # q4(4点) + q5(4点) = 8点
      params = { q1: '3', q2: '3', q3: '3', q4: '4', q5: '4' }
      diagnosis = Diagnosis.build_from_answers(params)
      expect(diagnosis.recommended_technical_max).to eq 3
    end
  end
end
