class OrganizationMembership < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :organization

  # Validations
  validates :user_id, uniqueness: { scope: :organization_id }
  validates :role, presence: true, inclusion: { in: %w[admin moderator member] }
  validates :joined_at, presence: true

  # Scopes
  scope :admins, -> { where(role: 'admin') }
  scope :moderators, -> { where(role: 'moderator') }
  scope :members, -> { where(role: 'member') }
  scope :recent, -> { order(joined_at: :desc) }

  # Methods
  def admin?
    role == 'admin'
  end

  def moderator?
    role == 'moderator'
  end

  def member?
    role == 'member'
  end

  def can_moderate?
    admin? || moderator?
  end

  def membership_duration
    return 0 unless joined_at
    (Date.current - joined_at.to_date).to_i
  end
end
