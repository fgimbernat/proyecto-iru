class AddVisibilityToSegmentations < ActiveRecord::Migration[7.2]
  def change
    add_column :areas, :visibility, :string, default: 'all'
    add_column :hierarchies, :visibility, :string, default: 'all'
    add_column :locations, :visibility, :string, default: 'all'
  end
end
