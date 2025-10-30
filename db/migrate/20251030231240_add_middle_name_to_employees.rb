class AddMiddleNameToEmployees < ActiveRecord::Migration[7.2]
  def change
    add_column :employees, :middle_name, :string
  end
end
