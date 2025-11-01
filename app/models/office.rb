# == Schema Information
#
# Table name: offices
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :text
#  address     :text
#  region_id   :bigint           not null
#  active      :boolean          default(TRUE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Office < ApplicationRecord
  # Associations
  belongs_to :region
  has_many :employees, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true
  validates :name, uniqueness: { scope: :region_id, case_sensitive: false }
  validates :active, inclusion: { in: [true, false] }
  validates :region, presence: true

  # Scopes
  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }
  scope :by_region, ->(region_id) { where(region_id: region_id) }

  # Delegations
  delegate :name, to: :region, prefix: true, allow_nil: true

  # Instance methods
  def employees_count
    employees.count
  end

  def full_name
    "#{name} - #{region_name}"
  end

  def deactivate!
    update(active: false)
  end

  def activate!
    update(active: true)
  end
end
