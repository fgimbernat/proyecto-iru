class CreateTimeOffRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :time_off_requests do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :time_off_policy, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :days_requested, null: false
      t.text :reason
      t.integer :status, default: 0, null: false
      t.references :approved_by, foreign_key: { to_table: :users }
      t.datetime :approved_at
      t.text :approval_notes

      t.timestamps
    end

    add_index :time_off_requests, :status
    add_index :time_off_requests, :start_date
    add_index :time_off_requests, [:employee_id, :status]
  end
end
