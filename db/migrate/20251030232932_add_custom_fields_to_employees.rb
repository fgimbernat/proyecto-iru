class AddCustomFieldsToEmployees < ActiveRecord::Migration[7.2]
  def change
    add_column :employees, :education, :string
    add_column :employees, :position_title, :string
    add_column :employees, :civil_status, :string
    add_column :employees, :languages, :string
    add_column :employees, :lives_in, :string
    add_column :employees, :salary_2023, :decimal
    add_column :employees, :salary_2024, :decimal
    add_column :employees, :emergency_contact, :string
    add_column :employees, :books, :text
    add_column :employees, :team, :string
  end
end
