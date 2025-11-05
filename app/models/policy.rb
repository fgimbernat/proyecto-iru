# frozen_string_literal: true

class Policy < ApplicationRecord
  # Enumerations
  enum :entitlement_type, {
    basic_annual: 'basic_annual',
    unlimited: 'unlimited'
  }, validate: true

  enum :period_type, {
    jan_dec: 'jan_dec',
    feb_jan: 'feb_jan',
    apr_mar: 'apr_mar',
    employee_anniversary: 'employee_anniversary'
  }, validate: true

  enum :accrual_frequency, {
    monthly: 'monthly',
    annual: 'annual'
  }, validate: true

  enum :accrual_timing, {
    start_of_cycle: 'start_of_cycle',
    end_of_cycle: 'end_of_cycle'
  }, validate: true

  enum :balance_precision, {
    decimals: 'decimals',
    rounded: 'rounded'
  }, validate: true

  enum :proration_calculation, {
    calendar_days: 'calendar_days',
    working_days: 'working_days'
  }, validate: true

  enum :carryover_expiration_unit, {
    months: 'months',
    years: 'years'
  }, prefix: :carryover_expires_in, validate: true

  enum :new_hire_block_unit, {
    days: 'days',
    weeks: 'weeks',
    months: 'months'
  }, prefix: :blocks_for, validate: true

  enum :attachment_requirement, {
    optional: 'optional',
    required: 'required',
    not_required: 'not_required'
  }, validate: true

  # Associations
  belongs_to :policy_type
  # TODO: Descomentar cuando se migre time_off_requests a usar policy_id
  # has_many :time_off_requests, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true, uniqueness: { scope: :policy_type_id }
  validates :annual_entitlement, numericality: { greater_than_or_equal_to: 0 }, if: :basic_annual?
  validates :carryover_limit, numericality: { greater_than_or_equal_to: 0 }, if: :enable_carryover?
  validates :carryover_expiration_amount, numericality: { greater_than: 0 }, if: :carryover_expires?
  validates :max_balance, numericality: { greater_than_or_equal_to: 0 }, if: :enable_max_balance?
  validates :min_advance_days, numericality: { greater_than_or_equal_to: 0 }
  validates :min_request_period, numericality: { greater_than: 0 }
  validates :max_request_period, numericality: { greater_than: 0 }
  validates :new_hire_block_days, numericality: { greater_than: 0 }, if: :block_new_hire_requests?

  validate :max_request_greater_than_min

  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :by_policy_type, ->(policy_type_id) { where(policy_type_id: policy_type_id) }
  scope :unlimited_policies, -> { where(entitlement_type: 'unlimited') }
  scope :basic_annual_policies, -> { where(entitlement_type: 'basic_annual') }
  scope :ordered_by_name, -> { order(name: :asc) }

  # Delegations
  delegate :unit, to: :policy_type, prefix: true

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

  def unlimited?
    entitlement_type == 'unlimited'
  end

  def uses_days?
    policy_type.days?
  end

  def uses_hours?
    policy_type.hours?
  end

  def allows_carryover?
    enable_carryover && carryover_limit.positive?
  end

  def has_max_balance?
    enable_max_balance && max_balance.positive?
  end

  def has_min_balance?
    enable_min_balance
  end

  def blocks_new_hires?
    block_new_hire_requests && new_hire_block_days.positive?
  end

  def requires_attachment?
    attachment_requirement == 'required'
  end

  def allows_optional_attachment?
    attachment_requirement == 'optional'
  end

  private

  def max_request_greater_than_min
    return unless max_request_period.present? && min_request_period.present?

    if max_request_period < min_request_period
      errors.add(:max_request_period, 'debe ser mayor o igual al período mínimo')
    end
  end
end
