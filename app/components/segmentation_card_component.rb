class SegmentationCardComponent < ViewComponent::Base
  def initialize(segmentation:)
    @segmentation = segmentation
  end

  def visibility_text
    case @segmentation.visibility
    when 'all'
      'Todos'
    when 'own_and_admins'
      'Propio usuario y administradores'
    else
      'Sólo administradores'
    end
  end
end
