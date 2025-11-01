class TimeOffPolicy < ApplicationRecord
  # Enums
  enum :policy_type, {
    vacation: 0,
    sick_leave: 1,
    personal_day: 2,
    study_leave: 3,
    maternity_leave: 4,
    paternity_leave: 5,
    bereavement_leave: 6,
    remote_work: 7,
    other: 99
  }, default: :vacation

  # Associations
  has_many :time_off_requests, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :policy_type, presence: true
  validates :days_per_year, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  # Scopes
  scope :active_policies, -> { where(active: true) }
  scope :by_type, ->(type) { where(policy_type: type) }

  # Class methods
  def self.policy_type_icons
    {
      vacation: 'fa-umbrella-beach',
      sick_leave: 'fa-briefcase-medical',
      personal_day: 'fa-person-walking',
      study_leave: 'fa-graduation-cap',
      maternity_leave: 'fa-baby-carriage',
      paternity_leave: 'fa-baby',
      bereavement_leave: 'fa-dove',
      remote_work: 'fa-house-laptop',
      other: 'fa-file-lines'
    }
  end

  def self.policy_type_colors
    {
      vacation: 'blue',
      sick_leave: 'red',
      personal_day: 'green',
      study_leave: 'purple',
      maternity_leave: 'pink',
      paternity_leave: 'indigo',
      bereavement_leave: 'gray',
      remote_work: 'yellow',
      other: 'slate'
    }
  end

  # Instance methods
  def display_icon
    icon.presence || self.class.policy_type_icons[policy_type.to_sym]
  end
  
  def display_icon_html
    "<i class='fa-solid #{display_icon}'></i>".html_safe
  end

  def display_color
    color.presence || self.class.policy_type_colors[policy_type.to_sym]
  end

  def policy_count
    time_off_requests.count
  end

  def employees_count
    time_off_requests.select(:employee_id).distinct.count
  end
end
