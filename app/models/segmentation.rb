class Segmentation < ApplicationRecord
  has_many :segmentation_items, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  validates :visibility, presence: true, inclusion: { in: %w[all own_and_admins admins_only] }
  
  # Devuelve los empleados que tienen algún item de esta segmentación
  def employees
    Employee.joins(employee_segmentations: :segmentation_item)
            .where(segmentation_items: { segmentation_id: id })
            .distinct
  end
end
