class CreateDepartments < ActiveRecord::Migration[7.2]
  def change
    create_table :departments do |t|
      t.string :name, null: false
      t.text :description
      t.integer :manager_id
      t.boolean :active, default: true, null: false

      t.timestamps
    end
    add_index :departments, :manager_id
    add_index :departments, :name
  end
end
