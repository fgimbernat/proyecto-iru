# frozen_string_literal: true

# BadgeComponent - Componente para badges/etiquetas
#
# Uso:
#   <%= render BadgeComponent.new(variant: :primary) do %>
#     Admin
#   <% end %>
#
#   <%= render BadgeComponent.new(variant: :success, size: :sm) do %>
#     Activo
#   <% end %>
#
# Parámetros:
#   - variant: :primary, :success, :warning, :error, :info, :neutral (default: :neutral)
#   - size: :sm, :md, :lg (default: :md)
#   - **html_options: Hash - Atributos HTML adicionales

class BadgeComponent < ViewComponent::Base
  VARIANTS = %i[primary success warning error info neutral].freeze
  SIZES = %i[sm md lg].freeze
  
  def initialize(variant: :neutral, size: :md, **html_options)
    @variant = validate_option(variant, VARIANTS, :neutral)
    @size = validate_option(size, SIZES, :md)
    @html_options = html_options
  end
  
  def call
    tag.span(content, class: css_classes, **@html_options.except(:class))
  end
  
  private
  
  def css_classes
    classes = ["badge", "badge--#{@variant}"]
    classes << "badge--#{@size}" if @size != :md
    classes << @html_options[:class] if @html_options[:class]
    classes.join(' ')
  end
  
  def validate_option(value, valid_options, default)
    valid_options.include?(value) ? value : default
  end
end
