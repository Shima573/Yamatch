class ProfilesController < ApplicationController
  # ログインしていない場合はログイン画面へ飛ばす
  before_action :authenticate_user!

  def show
    # resources :profiles の場合は params[:id] が必要ですが、
    # マイページとして使う場合は current_user を基本にします
    @user = current_user

    # 今後、診断履歴（@diagnoses）や
    # お気に入り（@favorite_mountains）をここで取得するように拡張できる
    @diagnosis = current_user.diagnoses.last
  end

  private

  def 
    
  end
end
