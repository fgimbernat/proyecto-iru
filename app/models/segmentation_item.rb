class SegmentationItem < ApplicationRecord
  belongs_to :segmentation
  has_many :employee_segmentations, dependent: :destroy
  has_many :employees, through: :employee_segmentations
  
  validates :name, presence: true
  validates :name, uniqueness: { scope: :segmentation_id }
end
