class CreateEmployees < ActiveRecord::Migration[7.2]
  def change
    create_table :employees do |t|
      t.string :employee_number, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :document_type, default: 0, null: false
      t.string :document_number, null: false
      t.date :birth_date
      t.integer :gender
      t.integer :marital_status
      t.string :email, null: false
      t.string :phone
      t.string :mobile
      t.text :address
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country, default: 'Argentina'
      t.date :hire_date, null: false
      t.date :termination_date
      t.integer :employment_status, default: 0, null: false
      t.integer :employment_type, default: 0, null: false
      t.references :position, null: false, foreign_key: true
      t.references :department, null: false, foreign_key: true
      t.integer :manager_id
      t.decimal :salary, precision: 10, scale: 2
      t.string :currency, default: 'ARS'
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :employees, :employee_number, unique: true
    add_index :employees, :document_number, unique: true
    add_index :employees, :email, unique: true
    add_index :employees, :manager_id
    add_index :employees, :employment_status
  end
end
