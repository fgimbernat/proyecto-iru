class CreateHolidays < ActiveRecord::Migration[7.2]
  def change
    create_table :holidays do |t|
      t.string :name, null: false
      t.date :date, null: false
      t.references :region, null: false, foreign_key: true
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :holidays, :date
    add_index :holidays, :active
    add_index :holidays, [:region_id, :date], unique: true
  end
end
