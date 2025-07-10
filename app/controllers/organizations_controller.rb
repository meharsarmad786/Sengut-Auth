class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy, :join, :leave, :analytics]
  before_action :require_organization_admin, only: [:edit, :update, :destroy]
  before_action :require_organization_membership, only: [:show, :analytics]

  def index
    @organizations = Organization.active.page(params[:page]).per(10)
    @user_organizations = current_user.organizations if user_signed_in?
  end

  def show
    @members = @organization.users.includes(:organization_memberships)
                           .page(params[:page]).per(20)
    @recent_activities = @organization.participation_activities.recent.limit(10)
    @user_role = current_user.organization_role(@organization)
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    
    if @organization.save
      # Make the creator an admin
      @organization.add_member(current_user, 'admin')
      redirect_to @organization, notice: 'Organization was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: 'Organization was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @organization.destroy
    redirect_to organizations_url, notice: 'Organization was successfully deleted.'
  end

  def join
    if @organization.can_user_join?(current_user)
      if current_user.minor? && !current_user.can_participate_without_consent?
        redirect_to @organization, alert: 'Parental consent is required to join this organization.'
      else
        @organization.add_member(current_user, 'member')
        
        # Track join activity
        ParticipationActivity.create!(
          user: current_user,
          organization: @organization,
          activity_type: 'join_organization',
          activity_data: { joined_at: Time.current }.to_json
        )
        
        redirect_to @organization, notice: 'You have successfully joined the organization.'
      end
    else
      redirect_to @organization, alert: 'Unable to join this organization.'
    end
  end

  def leave
    if current_user.member_of?(@organization)
      @organization.remove_member(current_user)
      
      # Track leave activity
      ParticipationActivity.create!(
        user: current_user,
        organization: @organization,
        activity_type: 'leave_organization',
        activity_data: { left_at: Time.current }.to_json
      )
      
      redirect_to organizations_path, notice: 'You have left the organization.'
    else
      redirect_to @organization, alert: 'You are not a member of this organization.'
    end
  end

  def analytics
    authorize! :read, :analytics
    
    @stats = @organization.participation_stats
    @member_stats = {
      total_members: @organization.members_count,
      adult_members: @organization.adult_members.count,
      minor_members: @organization.minor_members.count,
      admin_count: @organization.admin_users.count,
      moderator_count: @organization.moderator_users.count
    }
    
    @activity_chart_data = @organization.participation_activities
                                      .group_by_day(:created_at, last: 30.days)
                                      .count
    
    @user_role_chart_data = @organization.organization_memberships
                                        .group(:role).count
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :description, :active)
  end

  def require_organization_admin
    unless current_user.admin_of?(@organization)
      redirect_to @organization, alert: 'Access denied. Admin privileges required.'
    end
  end

  def require_organization_membership
    unless current_user.member_of?(@organization)
      redirect_to organizations_path, alert: 'Access denied. You must be a member to view this organization.'
    end
  end
end 