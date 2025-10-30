class CreateEmployeeSegmentations < ActiveRecord::Migration[7.2]
  def change
    create_table :employee_segmentations do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :area, null: false, foreign_key: true
      t.references :hierarchy, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
