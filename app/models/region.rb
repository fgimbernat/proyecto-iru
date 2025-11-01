# == Schema Information
#
# Table name: regions
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :text
#  active      :boolean          default(TRUE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Region < ApplicationRecord
  # Associations
  has_many :offices, dependent: :restrict_with_error
  has_many :holidays, dependent: :destroy
  has_many :employees, through: :offices

  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :active, inclusion: { in: [true, false] }

  # Scopes
  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }

  # Instance methods
  def offices_count
    offices.count
  end

  def holidays_count
    holidays.count
  end

  def employees_count
    employees.count
  end

  def deactivate!
    update(active: false)
  end

  def activate!
    update(active: true)
  end
end
