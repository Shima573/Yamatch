class FavoritesController < ApplicationController
  def create
    # 山を取得
    mountain = Mountain.find(params[:mountain_id])
    # お気に入り登録
    current_user.favorite(mountain)
    # リダイレクト
    redirect_back fallback_location: mountains_path
  end

  def destroy
    # 山を取得
    mountain = Mountain.find(params[:mountain_id])
    # お気に入り登録解除
    current_user.unfavorite(mountain)
    # リダイレクト
    redirect_back fallback_location: mountains_path
  end
end
