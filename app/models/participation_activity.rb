class ParticipationActivity < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :organization

  # Validations
  validates :activity_type, presence: true
  validates :activity_data, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_type, ->(type) { where(activity_type: type) }
  scope :this_month, -> { where(created_at: 1.month.ago..Time.current) }
  scope :this_week, -> { where(created_at: 1.week.ago..Time.current) }
  scope :today, -> { where(created_at: Date.current.beginning_of_day..Date.current.end_of_day) }

  # Class methods
  def self.activity_types
    %w[login logout join_organization leave_organization create_post comment like share]
  end

  def self.stats_for_organization(organization)
    activities = where(organization: organization)
    
    {
      total_activities: activities.count,
      unique_users: activities.distinct.count(:user_id),
      activities_by_type: activities.group(:activity_type).count,
      activities_this_month: activities.this_month.count,
      most_active_users: activities.joins(:user)
                                  .group('users.id', 'users.first_name', 'users.last_name')
                                  .order('count(*) desc')
                                  .limit(10)
                                  .count
    }
  end

  # Instance methods
  def activity_description
    case activity_type
    when 'login'
      "#{user.full_name} logged in"
    when 'logout'
      "#{user.full_name} logged out"
    when 'join_organization'
      "#{user.full_name} joined #{organization.name}"
    when 'leave_organization'
      "#{user.full_name} left #{organization.name}"
    else
      "#{user.full_name} performed #{activity_type}"
    end
  end

  def formatted_activity_data
    return {} unless activity_data
    JSON.parse(activity_data)
  rescue JSON::ParserError
    {}
  end
end
