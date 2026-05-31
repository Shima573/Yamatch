class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # Googleから届いた膨大なデータ（名前、メールアドレス、UIDなど）をモデルに渡す
    user = User.from_omniauth(request.env['omniauth.auth'])
    # 「ログイン」または「新規登録」する処理を書いていく
    if user&.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except('extra')
      redirect_to new_user_registration_url, alert: "Googleログインに失敗しました。メールアドレスが既に登録済みか、Google側でメール認証が完了していない可能性があります。"
    end
  end
end
