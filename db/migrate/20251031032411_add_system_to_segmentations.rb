class AddSystemToSegmentations < ActiveRecord::Migration[7.2]
  def change
    add_column :segmentations, :is_system, :boolean, default: false, null: false
    add_index :segmentations, :is_system
  end
end
