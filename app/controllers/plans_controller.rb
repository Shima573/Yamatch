class PlansController < ApplicationController
  def new
    @mountain = Mountain.find(params[:mountain_id])
    @plan = Plan.new
  end

  def create
    @mountain = Mountain.find(params[:mountain_id])
    @plan = current_user.plans.new(plan_params)
    # PlanはこのMountainに所属と関連付けを設定
    @plan.mountain = @mountain
    # 保存する対象はPlan
    @plan.save
  end

  private

  def plan_params
    params.require(:plan).permit(
      :title,
      :climbing_date,
      :companion_count,
      :route,
      :note,
      equipment: [],
    )
  end
end
