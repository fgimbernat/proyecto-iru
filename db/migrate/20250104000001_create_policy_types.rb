class CreatePolicyTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :policy_types do |t|
      t.string :name, null: false
      t.string :unit, null: false, default: 'days'
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :policy_types, :name, unique: true
    add_index :policy_types, :active
  end
end
