class UpdateEmployeeSegmentationsStructure < ActiveRecord::Migration[7.2]
  def change
    # Eliminar columnas antiguas de employee_segmentations
    remove_column :employee_segmentations, :area_id, :bigint
    remove_column :employee_segmentations, :hierarchy_id, :bigint
    remove_column :employee_segmentations, :location_id, :bigint
    
    # Agregar nueva columna para el item de segmentación
    add_reference :employee_segmentations, :segmentation_item, foreign_key: true
  end
end
