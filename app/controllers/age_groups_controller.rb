class AgeGroupsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_age_group, only: [:show]

  def index
    @age_groups = AgeGroup.all.order(:min_age)
    @current_user_age_group = current_user&.age_group
  end

  def show
    @users_in_age_group = @age_group.users.count if user_signed_in?
    @current_user_in_group = current_user&.age_group == @age_group
  end

  private

  def set_age_group
    @age_group = AgeGroup.find(params[:id])
  end
end 