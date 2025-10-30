class CreatePositions < ActiveRecord::Migration[7.2]
  def change
    create_table :positions do |t|
      t.string :title
      t.text :description
      t.references :department, null: false, foreign_key: true
      t.integer :level
      t.decimal :salary_range_min
      t.decimal :salary_range_max

      t.timestamps
    end
  end
end
