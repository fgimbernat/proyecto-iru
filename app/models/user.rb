class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Roles
  enum :role, { employee: 0, manager: 1, admin: 2 }, default: :employee

  # Associations
  has_one :employee, dependent: :destroy
  accepts_nested_attributes_for :employee, allow_destroy: true

  # Validations
  validates :role, presence: true

  # Callbacks
  after_create :build_employee_if_needed

  # Methods
  def admin?
    role == 'admin'
  end

  def manager?
    role == 'manager'
  end

  def employee?
    role == 'employee'
  end

  def display_name
    employee&.full_name || email
  end

  private

  def build_employee_if_needed
    build_employee unless employee.present?
  end
end
