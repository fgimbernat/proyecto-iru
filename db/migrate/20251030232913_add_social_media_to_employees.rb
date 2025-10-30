class AddSocialMediaToEmployees < ActiveRecord::Migration[7.2]
  def change
    add_column :employees, :linkedin, :string
    add_column :employees, :instagram, :string
    add_column :employees, :facebook, :string
    add_column :employees, :twitter, :string
  end
end
