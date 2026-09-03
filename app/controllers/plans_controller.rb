class PlansController < ApplicationController
  def index
    @plans = current_user.plans.includes(:mountain)
  end

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
    if @plan.save
      redirect_to profile_path(current_user)
    else
      render :new, status: :see_other
    end
  end

  def show
    @plan = current_user.plans.find(params[:id])
  end

  def edit
    @plan = current_user.plans.find(params[:id])
  end

  def update
    @plan = current_user.plans.find(params[:id])

    if @plan.update(plan_params)
      redirect_to plan_path(@plan)
    else
      render :edit,  status: :unprocessable_entity
    end
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
