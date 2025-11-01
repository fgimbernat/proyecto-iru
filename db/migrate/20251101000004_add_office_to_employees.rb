class AddOfficeToEmployees < ActiveRecord::Migration[7.2]
  def change
    add_reference :employees, :office, foreign_key: true, index: true
  end
end
