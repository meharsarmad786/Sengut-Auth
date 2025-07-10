class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :organization_memberships, dependent: :destroy
  has_many :organizations, through: :organization_memberships
  has_many :participation_activities, dependent: :destroy
  has_one :parental_consent, dependent: :destroy
  has_one_attached :profile_picture

  # Validations
  validates :first_name, :last_name, presence: true
  validates :date_of_birth, presence: true
  validates :phone, presence: true, format: { with: /\A[\+]?[1-9][\d]{0,15}\z/ }
  validate :age_must_be_valid

  # Scopes
  scope :adults, -> { where('date_of_birth <= ?', 18.years.ago.to_date) }
  scope :minors, -> { where('date_of_birth > ?', 18.years.ago.to_date) }

  # Methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def age
    return nil unless date_of_birth
    ((Date.current - date_of_birth) / 365.25).to_i
  end

  def minor?
    age < 18
  end

  def adult?
    age >= 18
  end

  def age_group
    return nil unless age
    AgeGroup.find_by(
      'min_age <= ? AND max_age >= ?', age, age
    )
  end

  def can_participate_without_consent?
    adult? || (minor? && parental_consent&.consent_given_at.present?)
  end

  def organization_role(organization)
    organization_memberships.find_by(organization: organization)&.role
  end

  def member_of?(organization)
    organizations.include?(organization)
  end

  def admin_of?(organization)
    organization_role(organization) == 'admin'
  end

  def moderator_of?(organization)
    %w[admin moderator].include?(organization_role(organization))
  end

  private

  def age_must_be_valid
    return unless date_of_birth

    if date_of_birth > Date.current
      errors.add(:date_of_birth, "cannot be in the future")
    elsif age > 120
      errors.add(:date_of_birth, "must be a valid age")
    end
  end
end
