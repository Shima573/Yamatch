class PagesController < ApplicationController
  # トップページは未ログインでも閲覧可能
  skip_before_action :authenticate_user!, only: [ :top ]

  def top
    redirect_to profile_path(current_user) if user_signed_in?
  end
end
