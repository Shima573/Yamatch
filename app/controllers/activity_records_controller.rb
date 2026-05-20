class ActivityRecordsController < ApplicationController
  before_action :set_activity_record, only: [:show, :edit, :update]

  def index
    @activity_records = current_user.activity_records.includes(photos: :image_attachment)
  end

  def new
    @activity_record = ActivityRecord.new
    @photo_errors = []
  end

  def create
    # トランザクション開始（全体の整合性保証）
    ActiveRecord::Base.transaction do
      # 投稿データ生成（まだDB未保存）
      @activity_record = current_user.activity_records.new(activity_record_params)

      # 画像データの整形（nil除去・最大3枚）
      images = Array(params[:activity_record][:images]).reject(&:blank?)

      # 画像を関連として紐付け（まだ保存しない）
      images.each do |image|
        @activity_record.photos.build(image: image)
      end
      # 全体まとめて保存（バリデーション実行）
      @activity_record.save!
    end
    # 成功時のリダイレクト
    redirect_to activity_records_path

  # 例外処理（バリデーション失敗など）
  rescue ActiveRecord::RecordInvalid
    # 再表示（エラー情報を持ったまま返す）
    render :new, status: :unprocessable_entity
  end

  def show
  end

  def edit
  end

  def update
    delete_photo_ids = params[:activity_record][:delete_photo_ids].to_s.split(",").reject(&:blank?)
    images = Array(params[:activity_record][:images]).reject(&:blank?)

    # トランザクションを開始して、失敗したらすべて無かったことにする
    ActiveRecord::Base.transaction do
      # 削除の処理
      delete_photo_ids.each do |photo_id|
        photo = @activity_record.photos.find_by(id: photo_id)
        photo.destroy! if photo
      end

      # 画像の追加保存（仮登録）
      images.each do |image|
        @activity_record.photos.build(image: image)
      end

      # フォームの他の項目（titleなど）をセットし、バリデーションを実行
      @activity_record.assign_attributes(activity_record_params)

      # 全体まとめて保存（バリデーション実行）
      @activity_record.save!
      redirect_to activity_record_path(@activity_record), notice: "登山記録を更新しました"
    end
  rescue ActiveRecord::RecordInvalid
    # 再表示（エラー情報を持ったまま返す）
    render :edit, status: :unprocessable_entity
  end

  private

  def activity_record_params
    params.require(:activity_record).permit(
      :title,
      :body,
      :climbed_at,
      :mountain_id,
    )
  end

  def set_activity_record
    @activity_record = current_user.activity_records.includes(photos: :image_attachment).find(params[:id])
  end
end
