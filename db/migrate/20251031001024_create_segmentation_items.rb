class CreateSegmentationItems < ActiveRecord::Migration[7.2]
  def change
    create_table :segmentation_items do |t|
      t.string :name
      t.references :segmentation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
