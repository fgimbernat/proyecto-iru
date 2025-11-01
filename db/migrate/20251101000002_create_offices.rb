class CreateOffices < ActiveRecord::Migration[7.2]
  def change
    create_table :offices do |t|
      t.string :name, null: false
      t.text :description
      t.text :address
      t.references :region, null: false, foreign_key: true
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :offices, :name
    add_index :offices, :active
    add_index :offices, [:region_id, :name], unique: true
  end
end
