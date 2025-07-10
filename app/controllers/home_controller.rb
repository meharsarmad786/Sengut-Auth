class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    if user_signed_in?
      @organizations = current_user.organizations.active
      @recent_activities = current_user.participation_activities.recent.limit(10)
      @user_stats = {
        organizations_count: @organizations.count,
        activities_count: @recent_activities.count,
        age_group: current_user.age_group&.name,
        requires_consent: current_user.minor? && !current_user.can_participate_without_consent?
      }
    else
      @public_organizations = Organization.active.limit(5)
      @age_groups = AgeGroup.all
    end
  end

  def dashboard
    @organizations = current_user.organizations.active
    @organization_stats = @organizations.map do |org|
      {
        organization: org,
        stats: org.participation_stats,
        role: current_user.organization_role(org)
      }
    end
    @recent_activities = current_user.participation_activities.recent.limit(20)
  end
end
