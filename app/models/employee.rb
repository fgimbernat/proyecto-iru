class Employee < ApplicationRecord
  # Associations
  belongs_to :position
  belongs_to :department
  belongs_to :user, optional: true
  belongs_to :manager, class_name: 'Employee', foreign_key: 'manager_id', optional: true
  has_many :subordinates, class_name: 'Employee', foreign_key: 'manager_id', dependent: :nullify
  has_many :employee_segmentations, dependent: :destroy
  has_many :segmentation_items, through: :employee_segmentations

  # Enums
  enum :document_type, { dni: 0, passport: 1, other_document: 2 }, default: :dni
  enum :gender, { male: 0, female: 1, non_binary: 2, prefer_not_to_say: 3 }
  enum :marital_status, { single: 0, married: 1, divorced: 2, widowed: 3 }
  enum :employment_status, { active: 0, on_leave: 1, terminated: 2, suspended: 3 }, default: :active
  enum :employment_type, { full_time: 0, part_time: 1, contractor: 2, intern: 3 }, default: :full_time

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :document_number, presence: true, uniqueness: true
  validates :employee_number, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :hire_date, presence: true
  validates :salary, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validate :termination_date_after_hire_date

  # Callbacks
  before_validation :generate_employee_number, on: :create
  before_validation :set_default_country

  # Scopes
  scope :active_employees, -> { where(employment_status: :active) }
  scope :by_department, ->(department_id) { where(department_id: department_id) }
  scope :by_position, ->(position_id) { where(position_id: position_id) }
  scope :hired_between, ->(start_date, end_date) { where(hire_date: start_date..end_date) }

  # Instance methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def years_of_service
    return 0 unless hire_date
    end_date = terminated? ? termination_date : Date.today
    ((end_date - hire_date) / 365.25).floor
  end

  def terminated?
    employment_status == 'terminated' && termination_date.present?
  end

  private

  def generate_employee_number
    return if employee_number.present?
    
    last_employee = Employee.order(created_at: :desc).first
    number = last_employee ? last_employee.employee_number.to_i + 1 : 1
    self.employee_number = format('%05d', number)
  end

  def set_default_country
    self.country ||= 'Argentina'
    self.currency ||= 'ARS'
  end

  def termination_date_after_hire_date
    return unless termination_date.present? && hire_date.present?
    
    if termination_date < hire_date
      errors.add(:termination_date, "must be after hire date")
    end
  end
end
