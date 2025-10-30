class EmployeeSegmentation < ApplicationRecord
  belongs_to :employee
  belongs_to :area, optional: true
  belongs_to :hierarchy, optional: true
  belongs_to :location, optional: true
end
