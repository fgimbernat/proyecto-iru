module Admin
  module SegmentationHelper
    # Devuelve el texto de visibilidad traducido
    def visibility_label(visibility)
      case visibility
      when 'all' then 'Todos'
      when 'own_and_admins' then 'Propio usuario y administradores'
      when 'admins_only' then 'Sólo administradores'
      else visibility
      end
    end
    
    # Devuelve las opciones de visibilidad para select
    def visibility_options
      Segmentation::VISIBILITY_OPTIONS
    end
    
    # Clases CSS para badges de sistema
    def system_badge_classes
      "inline-flex items-center px-2 py-0.5 rounded-md text-[10px] font-semibold bg-blue-50 text-blue-700 border border-blue-200"
    end
    
    # Clases CSS comunes para botones
    def primary_button_classes
      "inline-flex items-center px-5 py-2.5 border border-transparent rounded-xl text-sm font-semibold text-white bg-blue-600 hover:bg-blue-700 transition-all shadow-md hover:shadow-lg"
    end
    
    def secondary_button_classes
      "px-4 py-2 text-sm font-medium text-gray-700 hover:text-gray-900 transition-colors"
    end
    
    # Genera el Alpine.js x-data para una card de segmentación
    def segmentation_card_alpine_data(segmentation)
      {
        menuOpen: false,
        showEditModal: false,
        editName: segmentation.name,
        editVisibility: segmentation.visibility
      }.to_json.gsub('"', "'")
    end
  end
end
