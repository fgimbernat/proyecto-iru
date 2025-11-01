# frozen_string_literal: true

# UI::ButtonComponent - Componente reutilizable para botones
#
# Uso:
#   <%= render UI::ButtonComponent.new(variant: :primary) do %>
#     Guardar
#   <% end %>
#
#   <%= render UI::ButtonComponent.new(variant: :danger, size: :sm, href: admin_user_path(@user)) do %>
#     Eliminar
#   <% end %>
#
# Parámetros:
#   - variant: :primary, :secondary, :success, :danger, :ghost, :outline (default: :primary)
#   - size: :sm, :md, :lg (default: :md)
#   - href: String - Si se proporciona, renderiza un link en lugar de un button
#   - icon: String - Clase CSS para el icono (opcional)
#   - disabled: Boolean (default: false)
#   - type: String - Tipo de botón: 'button', 'submit', 'reset' (default: 'button')
#   - **html_options: Hash - Cualquier otro atributo HTML (class, data, etc.)

class ButtonComponent < ViewComponent::Base
  VARIANTS = %i[primary secondary success danger ghost outline].freeze
  SIZES = %i[sm md lg].freeze
  
  def initialize(variant: :primary, size: :md, href: nil, icon: nil, disabled: false, type: 'button', **html_options)
    @variant = validate_option(variant, VARIANTS, :primary)
    @size = validate_option(size, SIZES, :md)
      @href = href
      @icon = icon
      @disabled = disabled
      @type = type
      @html_options = html_options
    end
    
    def call
      if @href
        link_to @href, **link_options do
          button_content
        end
      else
        tag.button(**button_options) do
          button_content
        end
      end
    end
    
    private
    
    def button_content
      safe_join([icon_tag, content].compact)
    end
    
    def icon_tag
      return nil unless @icon
      
      tag.span(class: @icon, aria: { hidden: true })
    end
    
    def button_options
      {
        type: @type,
        disabled: @disabled,
        class: css_classes,
        **@html_options
      }
    end
    
    def link_options
      {
        class: css_classes,
        **@html_options
      }
    end
    
    def css_classes
      classes = ["btn", "btn--#{@variant}", "btn--#{@size}"]
      classes << @html_options[:class] if @html_options[:class]
      classes.join(' ')
    end
    
  def validate_option(value, valid_options, default)
    valid_options.include?(value) ? value : default
  end
end
