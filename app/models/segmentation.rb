class Segmentation < ApplicationRecord
  # Concerns
  include SystemProtectable
  
  # Constantes
  VISIBILITY_OPTIONS = [
    ['Todos', 'all'],
    ['Propio usuario y administradores', 'own_and_admins'],
    ['Sólo administradores', 'admins_only']
  ].freeze
  
  VISIBILITY_VALUES = %w[all own_and_admins admins_only].freeze
  
  # Asociaciones
  has_many :segmentation_items, dependent: :destroy
  
  # Validaciones
  validates :name, presence: true, uniqueness: true
  validates :visibility, presence: true, inclusion: { in: VISIBILITY_VALUES }
  
  # Scopes (adicionales a los del concern SystemProtectable)
  # Los scopes system_segmentations y custom_segmentations ya están definidos en SystemProtectable
  
  # Métodos de instancia públicos
  def employees
    Employee.joins(employee_segmentations: :segmentation_item)
            .where(segmentation_items: { segmentation_id: id })
            .distinct
  end
  
  def system_segmentation?
    is_system
  end
  
  # Métodos de presentación (Decorator pattern inline)
  def visibility_text
    case visibility
    when 'all' then 'Todos'
    when 'own_and_admins' then 'Propio usuario y administradores'
    when 'admins_only' then 'Sólo administradores'
    else visibility
    end
  end
  
  def items_count
    segmentation_items.size
  end
  
  def employees_count
    employees.count
  end
  
  private
  
  # Los métodos de protección del sistema ahora están en el concern SystemProtectable
end
