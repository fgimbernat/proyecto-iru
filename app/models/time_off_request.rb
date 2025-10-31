class TimeOffRequest < ApplicationRecord
  # Enums
  enum :status, {
    pending: 0,
    approved: 1,
    rejected: 2,
    cancelled: 3
  }, default: :pending

  # Associations
  belongs_to :employee
  belongs_to :time_off_policy
  belongs_to :approved_by, class_name: 'User', optional: true

  # Validations
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :days_requested, presence: true, numericality: { greater_than: 0 }
  validate :end_date_after_start_date

  # Callbacks
  before_validation :calculate_days_requested, if: -> { start_date.present? && end_date.present? }

  # Scopes
  scope :pending_requests, -> { where(status: :pending) }
  scope :approved_requests, -> { where(status: :approved) }
  scope :for_employee, ->(employee_id) { where(employee_id: employee_id) }
  scope :for_policy, ->(policy_id) { where(time_off_policy_id: policy_id) }
  scope :in_date_range, ->(start_date, end_date) { 
    where("start_date <= ? AND end_date >= ?", end_date, start_date) 
  }

  # Instance methods
  def pending?
    status == 'pending'
  end

  def approved?
    status == 'approved'
  end

  def rejected?
    status == 'rejected'
  end

  def cancelled?
    status == 'cancelled'
  end

  def approve!(user, notes = nil)
    update(
      status: :approved,
      approved_by: user,
      approved_at: Time.current,
      approval_notes: notes
    )
  end

  def reject!(user, notes = nil)
    update(
      status: :rejected,
      approved_by: user,
      approved_at: Time.current,
      approval_notes: notes
    )
  end

  private

  def end_date_after_start_date
    return unless end_date.present? && start_date.present?
    
    if end_date < start_date
      errors.add(:end_date, "debe ser posterior a la fecha de inicio")
    end
  end

  def calculate_days_requested
    self.days_requested = (end_date - start_date).to_i + 1
  end
end
