class CreateTimeOffPolicies < ActiveRecord::Migration[7.2]
  def change
    create_table :time_off_policies do |t|
      t.string :name, null: false
      t.text :description
      t.integer :policy_type, default: 0, null: false
      t.integer :days_per_year
      t.boolean :requires_approval, default: true
      t.boolean :active, default: true
      t.string :icon
      t.string :color

      t.timestamps
    end

    add_index :time_off_policies, :policy_type
    add_index :time_off_policies, :active
  end
end
