class CreateSegmentations < ActiveRecord::Migration[7.2]
  def change
    create_table :segmentations do |t|
      t.string :name
      t.string :visibility

      t.timestamps
    end
  end
end
