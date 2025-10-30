class Position < ApplicationRecord
  # Associations
  belongs_to :department
  has_many :employees, dependent: :nullify

  # Enums
  enum :level, {
    entry: 0,
    junior: 1,
    mid: 2,
    senior: 3,
    lead: 4,
    manager: 5,
    director: 6
  }, default: :entry

  # Validations
  validates :title, presence: true
  validates :level, presence: true
  validates :salary_range_min, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :salary_range_max, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validate :salary_range_valid

  # Scopes
  scope :by_level, ->(level) { where(level: level) }
  scope :in_department, ->(department_id) { where(department_id: department_id) }

  private

  def salary_range_valid
    if salary_range_min.present? && salary_range_max.present? && salary_range_min > salary_range_max
      errors.add(:salary_range_max, "must be greater than or equal to minimum salary")
    end
  end
end
