class ParentalConsent < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :parent_name, presence: true
  validates :parent_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :consent_given_at, presence: true
  validate :user_must_be_minor

  # Scopes
  scope :given, -> { where.not(consent_given_at: nil) }
  scope :recent, -> { order(consent_given_at: :desc) }

  # Methods
  def consent_given?
    consent_given_at.present?
  end

  def consent_expired?
    return false unless consent_given_at
    consent_given_at < 2.years.ago
  end

  def valid_consent?
    consent_given? && !consent_expired?
  end

  def parent_contact_info
    "#{parent_name} (#{parent_email})"
  end

  private

  def user_must_be_minor
    return unless user
    errors.add(:user, "must be a minor to require parental consent") unless user.minor?
  end
end
