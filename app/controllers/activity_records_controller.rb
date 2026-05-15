class ActivityRecordsController < ApplicationController
  def index
    @activity_records = current_user.activity_records
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
      images = Array(params[:activity_record][:images]).reject(&:blank?).first(3)

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

  private

  def activity_record_params
    params.require(:activity_record).permit(
      :title,
      :body,
      :climbed_at,
      :mountain_id,
    )
  end
end
