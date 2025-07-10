class Organization < ApplicationRecord
  # Associations
  has_many :organization_memberships, dependent: :destroy
  has_many :users, through: :organization_memberships
  has_many :participation_activities, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  # Methods
  def members_count
    users.count
  end

  def admin_users
    users.where(organization_memberships: { role: 'admin' })
  end

  def moderator_users
    users.where(organization_memberships: { role: ['admin', 'moderator'] })
  end

  def member_users
    users.where(organization_memberships: { role: 'member' })
  end

  def adult_members
    cutoff_date = Date.current - 18.years
    users.where('users.date_of_birth <= ?', cutoff_date)
  end

  def minor_members
    cutoff_date = Date.current - 18.years
    users.where('users.date_of_birth > ?', cutoff_date)
  end

  def participation_stats
    {
      total_activities: participation_activities.count,
      unique_participants: participation_activities.distinct.count(:user_id),
      activities_this_month: participation_activities.where(
        'created_at >= ?', 1.month.ago
      ).count
    }
  end

  def can_user_join?(user)
    active? && !users.include?(user)
  end

  def add_member(user, role = 'member')
    return false unless can_user_join?(user)
    
    organization_memberships.create(
      user: user,
      role: role,
      joined_at: Time.current
    )
  end

  def remove_member(user)
    organization_memberships.find_by(user: user)&.destroy
  end
end
