# ViewComponents - Guía de Uso

Esta aplicación utiliza ViewComponents para crear componentes UI reutilizables, testeables y mantenibles.

## 📦 Componentes Disponibles

### ButtonComponent

Botón reutilizable con múltiples variantes y tamaños.

**Uso básico:**
```erb
<%= render ButtonComponent.new(variant: :primary) do %>
  Guardar
<% end %>
```

**Con ícono:**
```erb
<%= render ButtonComponent.new(variant: :success, icon: "icon-check") do %>
  Confirmar
<% end %>
```

**Como link:**
```erb
<%= render ButtonComponent.new(variant: :danger, href: admin_user_path(@user), data: { turbo_method: :delete, turbo_confirm: "¿Estás seguro?" }) do %>
  Eliminar
<% end %>
```

**Tamaños:**
```erb
<%= render ButtonComponent.new(size: :sm) do %>Pequeño<% end %>
<%= render ButtonComponent.new(size: :md) do %>Mediano<% end %>
<%= render ButtonComponent.new(size: :lg) do %>Grande<% end %>
```

**Variantes:**
- `:primary` - Botón principal (azul)
- `:secondary` - Botón secundario (gris)
- `:success` - Acción exitosa (verde)
- `:danger` - Acción destructiva (rojo)
- `:ghost` - Botón transparente
- `:outline` - Botón con borde

---

### AlertComponent

Alertas y notificaciones con diferentes tipos.

**Uso básico:**
```erb
<%= render AlertComponent.new(type: :success) do %>
  Usuario creado exitosamente
<% end %>
```

**Con título:**
```erb
<%= render AlertComponent.new(type: :error, title: "Error de validación") do %>
  Por favor corrige los errores antes de continuar.
<% end %>
```

**Dismissible:**
```erb
<%= render AlertComponent.new(type: :info, dismissible: true) do %>
  Esta es una notificación que se puede cerrar.
<% end %>
```

**Tipos:**
- `:success` - Éxito (verde)
- `:error` - Error (rojo)
- `:warning` - Advertencia (amarillo)
- `:info` - Información (azul)

---

### BadgeComponent

Etiquetas pequeñas para mostrar estados o categorías.

**Uso básico:**
```erb
<%= render BadgeComponent.new(variant: :primary) do %>
  Admin
<% end %>
```

**Tamaños:**
```erb
<%= render BadgeComponent.new(size: :sm, variant: :success) do %>Pequeño<% end %>
<%= render BadgeComponent.new(size: :md, variant: :warning) do %>Mediano<% end %>
<%= render BadgeComponent.new(size: :lg, variant: :error) do %>Grande<% end %>
```

**Variantes:**
- `:primary` - Azul
- `:success` - Verde
- `:warning` - Amarillo
- `:error` - Rojo
- `:info` - Azul claro
- `:neutral` - Gris (default)

---

## 🎨 Ejemplos Prácticos

### Formulario con botones
```erb
<div class="form-actions">
  <%= render ButtonComponent.new(type: "submit", variant: :primary) do %>
    Guardar Usuario
  <% end %>
  
  <%= render ButtonComponent.new(variant: :ghost, href: admin_users_path) do %>
    Cancelar
  <% end %>
</div>
```

### Lista con badges de estado
```erb
<% @users.each do |user| %>
  <div class="user-item">
    <h3><%= user.email %></h3>
    <%= render BadgeComponent.new(variant: user.active? ? :success : :error) do %>
      <%= user.active? ? "Activo" : "Inactivo" %>
    <% end %>
  </div>
<% end %>
```

### Alertas en flash messages
```erb
<% if notice %>
  <%= render AlertComponent.new(type: :success, dismissible: true) do %>
    <%= notice %>
  <% end %>
<% end %>
```

---

## 🧪 Testing

Los componentes se pueden testear fácilmente:

```ruby
# test/components/button_component_test.rb
require "test_helper"

class ButtonComponentTest < ViewComponent::TestCase
  def test_renders_primary_button
    render_inline(ButtonComponent.new(variant: :primary)) { "Click me" }
    
    assert_selector "button.btn.btn--primary", text: "Click me"
  end
  
  def test_renders_as_link
    render_inline(ButtonComponent.new(href: "/test")) { "Link" }
    
    assert_selector "a[href='/test']", text: "Link"
  end
end
```

---

## 📚 Recursos

- [ViewComponent Documentation](https://viewcomponent.org/)
- [ViewComponent Guide](https://viewcomponent.org/guide/)
- [Testing ViewComponents](https://viewcomponent.org/guide/testing.html)

