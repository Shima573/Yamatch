require 'rails_helper'

RSpec.describe "Plans", type: :request do
  describe "GET /mountains/:mountain_id/plans/new" do
    it "未ログインの場合はログイン画面へリダイレクトされる" do
      mountain = FactoryBot.create(:mountain)
      get new_mountain_plan_path(mountain)
      expect(response).to redirect_to (new_user_session_path)
    end
    it "ログインの場合は新規作成画面の表示" do
      user = FactoryBot.create(:user) # テスト用のユーザーをDBに保存する
      sign_in user # そのユーザーがログインした状態を作る
      mountain = FactoryBot.create(:mountain)
      get new_mountain_plan_path(mountain)
      expect(response).to have_http_status(:success)
    end
  end


  describe "POST /mountains/:mountain_id/plans" do
    it "正常なデータの場合は登山プランが作成される" do
      user = FactoryBot.create(:user)
      sign_in user
      mountain = FactoryBot.create(:mountain)

      # ここにPlanが1件増えることを確認する処理を書く
      expect {
        post mountain_plans_path(mountain), params: {
          plan: {
            title: "テスト登山",
            climbing_date: Date.current,
            companion_count: 2
          }
        }
      }.to change(Plan, :count).by(1)

      expect(response).to redirect_to (plans_path)
    end

    it "異常なデータの場合は登山プランが作成されない" do
      user = FactoryBot.create(:user)
      sign_in user
      mountain = FactoryBot.create(:mountain)

      expect {
        post mountain_plans_path(mountain), params: {
          plan: {
            title: "や" * 51,
            climbing_date: Date.current,
            companion_count: 2
          }
        }
      }.not_to change(Plan, :count)

      expect(response).to have_http_status(:see_other)
    end
  end
end
