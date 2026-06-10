class ApplicationController < ActionController::Base
  # デフォルトで全ページをログイン必須にする
  before_action :authenticate_user!
  # Deviseのコントローラー（登録、ログイン、パスワード編集など）が動くときだけ、
  # configure_permitted_parameters メソッドを実行する
  before_action :configure_permitted_parameters, if: :devise_controller?


  # ログイン後の遷移先を指定するメソッド
  def after_sign_in_path_for(resource)
    profile_path(resource) # resource はログインしたユーザーオブジェクト（current_userと同じ）
  end

  # # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  protected

  def configure_permitted_parameters
    # サインアップ（新規登録）の際に、emailとpassword以外に「name」の保存も許可する
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :avatar ])

    # アカウント更新（プロフィール編集）の際に、emailとpassword以外に「name」の変更も許可する
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :avatar, :prefecture ])
  end

  # Deviseが提供する、ログイン後にどこに遷移させるかを決めるメソッド
  def after_sign_in_path_for(resource)
    # 💡 ここで「ログイン前の診断データ」があるかどうかをチェックする
    if session[:pending_diagnosis]
      # 1. セッションのデータを使って、新しく Diagnosis インスタンスを作る
      diagnosis = Diagnosis.new(session[:pending_diagnosis])
      # 2. そのインスタンスの user を current_user (今回は引数の resource でも可) にする
      diagnosis.user = resource
      # 3. データベースに保存する
      diagnosis.save!
      # 4. セッションを空にする（消しておかないと、次回ログイン時にも反応してしまうため）
      session.delete(:pending_diagnosis)
      # 5. 保存した診断結果の詳細画面のパスを返す
      diagnosis_path(diagnosis)
    else
      # 診断データがない場合は、通常のトップページやマイページなどのパスを返す
      root_path # あるいは super(resource) など
    end
  end
end
