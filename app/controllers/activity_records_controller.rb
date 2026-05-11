class ActivityRecordsController < ApplicationController
  def index
    @activity_records = current_user.activity_records
  end

  def new
    @activity_record = ActivityRecord.new
  end

  def create
    @activity_record = current_user.activity_records.build(activity_record_params)

    if @activity_record.save
      # 成功
      redirect_to activity_records_path
    else
      # 失敗
      render :new, status: :unprocessable_entity
    end
  end

  private

  def activity_record_params
    params.require(:activity_record).permit(
      :title,
      :body,
      :climbed_at,
      :mountain_id
    )
  end
end
