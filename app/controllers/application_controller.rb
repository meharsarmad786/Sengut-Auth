class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :track_user_activity

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :date_of_birth, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :date_of_birth, :phone, :profile_picture])
  end

  def track_user_activity
    return unless user_signed_in? && current_user.organizations.any?

    # Track login activity
    if session[:last_activity_tracked].nil? || session[:last_activity_tracked] < 1.hour.ago
      current_user.organizations.each do |organization|
        ParticipationActivity.create!(
          user: current_user,
          organization: organization,
          activity_type: 'login',
          activity_data: { 
            ip_address: request.remote_ip,
            user_agent: request.user_agent,
            timestamp: Time.current
          }.to_json
        )
      end
      session[:last_activity_tracked] = Time.current
    end
  end

  def require_organization_membership(organization)
    unless current_user.member_of?(organization)
      redirect_to root_path, alert: "Access denied. You must be a member of #{organization.name}."
    end
  end

  def require_organization_admin(organization)
    unless current_user.admin_of?(organization)
      redirect_to root_path, alert: "Access denied. You must be an admin of #{organization.name}."
    end
  end

  def require_parental_consent
    if current_user.minor? && !current_user.can_participate_without_consent?
      redirect_to new_parental_consent_path, alert: "Parental consent is required for participation."
    end
  end
end
