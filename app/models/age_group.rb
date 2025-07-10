class AgeGroup < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :min_age, presence: true, 
            numericality: { greater_than_or_equal_to: 0 }
  validates :max_age, presence: true,
            numericality: { greater_than: :min_age }
  validates :description, presence: true

  # Scopes
  scope :for_age, ->(age) { where('min_age <= ? AND max_age >= ?', age, age) }
  scope :for_minors, -> { where('max_age < ?', 18) }
  scope :for_adults, -> { where('min_age >= ?', 18) }

  # Methods
  def includes_age?(age)
    return false unless age
    age >= min_age && age <= max_age
  end

  def age_range
    "#{min_age}-#{max_age} years"
  end

  def users_in_group
    User.where(
      'EXTRACT(YEAR FROM age(date_of_birth)) BETWEEN ? AND ?',
      min_age, max_age
    )
  end

  # Alias for consistency
  def users
    users_in_group
  end

  def requires_parental_consent?
    max_age < 18
  end
end
