class PlansController < ApplicationController
  def new
    @mountain = Mountain.find(params[:mountain_id])
    @plan = Plan.new
  end

  def create
  end
end
