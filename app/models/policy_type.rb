# frozen_string_literal: true

class PolicyType < ApplicationRecord
  # Enumerations
  enum :unit, { days: 'days', hours: 'hours' }, validate: true

  # Associations
  has_many :policies, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :unit, presence: true

  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :by_unit, ->(unit) { where(unit: unit) }
  scope :ordered_by_name, -> { order(name: :asc) }

  # Instance methods
  def deactivate!
    update!(active: false)
  end

  def activate!
    update!(active: true)
  end

  def toggle_status!
    update!(active: !active)
  end
end
