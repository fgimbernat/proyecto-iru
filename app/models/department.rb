class Department < ApplicationRecord
  # Associations
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id', optional: true
  has_many :positions, dependent: :destroy
  has_many :employees, dependent: :nullify

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :active, inclusion: { in: [true, false] }

  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  # Methods
  def deactivate!
    update(active: false)
  end

  def activate!
    update(active: true)
  end
end
