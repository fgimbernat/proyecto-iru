class Location < ApplicationRecord
  has_many :employee_segmentations, dependent: :destroy
  has_many :employees, through: :employee_segmentations

  validates :name, presence: true, uniqueness: true
end
