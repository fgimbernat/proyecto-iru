# Concern para modelos que pueden ser protegidos del sistema
# Uso: include SystemProtectable
module SystemProtectable
  extend ActiveSupport::Concern

  included do
    # Scope para obtener registros del sistema
    scope :system_records, -> { where(is_system: true) }
    scope :custom_records, -> { where(is_system: false) }
    
    # Validación para prevenir eliminación desde la base de datos
    before_destroy :prevent_system_record_deletion, prepend: true
  end

  # Métodos de instancia
  def system_record?
    is_system == true
  end
  
  def custom_record?
    !system_record?
  end

  private

  def prevent_system_record_deletion
    if system_record?
      errors.add(:base, I18n.t('errors.messages.cannot_delete_system_record', 
                                model: self.class.model_name.human))
      throw(:abort)
    end
  end
end
