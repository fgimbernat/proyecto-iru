class EmployeeSegmentation < ApplicationRecord
  belongs_to :employee
  belongs_to :segmentation_item
  
  validates :segmentation_item_id, uniqueness: { scope: :employee_id }
end
