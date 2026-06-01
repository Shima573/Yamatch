class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable,
         omniauth_providers: [ :google_oauth2 ]

  has_many :favorites, dependent: :destroy
  has_many :favorite_mountains, through: :favorites, source: :mountain
  has_many :activity_records, dependent: :destroy

  # 名前を必須にし、50文字以内にする
  validates :name, presence: true, length: { maximum: 50 }

  # 診断結果との関連付け（1対多）
  has_many :diagnoses, dependent: :destroy

  has_one_attached :avatar

  # Google認証用のユーザー検索・作成メソッド
  def self.from_omniauth(auth)
    return nil if auth.provider == "google_oauth2" && !auth.info.email_verified
    return nil if auth.info.email.blank?

    # 既存のGoogleログインユーザーがいれば返す
    user = find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    # メアド重複による乗っ取り防止
    return nil if User.exists?(email: auth.info.email)

    # 初回Googleログイン時の新規作成
    create do |u|
      u.provider = auth.provider
      u.uid      = auth.uid
      u.email    = auth.info.email
      u.name     = auth.info.name
      u.password = SecureRandom.hex(16)
    end
  end

  # Googleログインユーザーはパスワード入力を不要にする
  def password_required?
    super && provider.blank?
  end

  # Googleログインユーザーはパスワード変更を不可にする
  def password_changeable?
    provider.blank?
  end

  # お気に入り関連
  # 登録する
  def favorite(mountain)
    favorite_mountains << mountain
  end

  # 解除する
  def unfavorite(mountain)
    favorites.where(mountain_id: mountain.id).delete_all
  end

  # 状態を確認する
  def favorited?(mountain)
    favorites.exists?(mountain_id: mountain.id)
  end

  # ファイルの種類とサイズのバリデーション（gem ActiveStorage Validationを使用）
  ACCEPTED_CONTENT_TYPES = %w[image/jpeg image/png image/gif image/webp].freeze
  validates :avatar, content_type: ACCEPTED_CONTENT_TYPES, size: { less_than_or_equal_to: 5.megabytes }
end
