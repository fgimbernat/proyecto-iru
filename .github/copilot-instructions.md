# GitHub Copilot Instructions - Proyecto IRU RRHH

## 📋 Contexto del Proyecto

Sistema de gestión de Recursos Humanos desarrollado en Ruby on Rails 7.2.3 con PostgreSQL, enfocado en la administración de empleados, departamentos, posiciones y políticas de tiempo libre.

### Stack Tecnológico

- **Backend**: Ruby 3.3.6, Rails 7.2.3
- **Base de datos**: PostgreSQL 16
- **Cache/Sessions**: Redis 7
- **Frontend**: 
  - Tailwind CSS 4.4 (utility-first CSS)
  - Alpine.js 3.x (JavaScript interactivity)
  - SCSS con arquitectura 7-1 (componentes reutilizables)
- **Componentes**: ViewComponent 3.x (sin namespaces)
- **Autenticación**: Devise 4.9
- **Autorización**: Pundit 2.3
- **Paginación**: Kaminari 1.2
- **Servidor**: Puma 7.1.0
- **Containerización**: Docker con docker-compose

### Comandos Docker

```bash
# Levantar proyecto
docker-compose up -d

# Ver logs
docker-compose logs -f web

# Ejecutar comandos Rails
docker-compose exec web bin/rails [comando]

# Acceder a consola
docker-compose exec web bin/rails console

# Reiniciar servidor
docker-compose restart web
```

## 🏗️ Arquitectura y Patrones

### ViewComponents (SIN namespace)

**✅ USAR ESTO:**
```ruby
# app/components/card_component.rb
class CardComponent < ViewComponent::Base
  def initialize(title:, **html_options)
    @title = title
    @html_options = html_options
  end
end
```

```erb
<!-- En las vistas -->
<%= render CardComponent.new(title: "Título") do %>
  Contenido
<% end %>
```

**❌ NO USAR namespace UI::**
```ruby
# ❌ INCORRECTO - Rails 7.2 tiene problemas de autoloading con namespaces en components
module UI
  class CardComponent < ViewComponent::Base
  end
end
```

### Componentes Existentes

1. **ButtonComponent**: Botones con variantes (primary, secondary, success, danger, ghost, outline) y tamaños (sm, md, lg)
2. **AlertComponent**: Alertas/notificaciones (success, error, warning, info) con opción dismissible
3. **BadgeComponent**: Etiquetas/badges para estados (primary, success, warning, error, info, neutral)

### SCSS - Arquitectura 7-1

Estructura organizada en `app/assets/stylesheets/`:

```
stylesheets/
├── abstracts/
│   ├── _variables.scss  # Design tokens (colores, tipografía, espaciado)
│   └── _mixins.scss     # Mixins reutilizables
├── base/
│   └── _reset.scss      # CSS reset
├── components/
│   ├── _buttons.scss
│   ├── _alerts.scss
│   ├── _cards.scss
│   ├── _badges.scss
│   └── _forms.scss
├── layout/
│   ├── _sidebar.scss
│   └── _header.scss
└── admin.scss           # Entry point
```

**Variables importantes:**
```scss
// Colores (app/assets/stylesheets/abstracts/_variables.scss)
$color-primary: #3B82F6;
$color-success: #10B981;
$color-warning: #F59E0B;
$color-error: #EF4444;

// Espaciado (escala modular)
$spacing-xs: 0.25rem;  // 4px
$spacing-sm: 0.5rem;   // 8px
$spacing-md: 1rem;     // 16px
$spacing-lg: 1.5rem;   // 24px
$spacing-xl: 2rem;     // 32px

// Breakpoints responsive
$breakpoint-sm: 640px;
$breakpoint-md: 768px;
$breakpoint-lg: 1024px;
$breakpoint-xl: 1280px;
```

**Mixins útiles:**
```scss
// Responsive
@include respond-to(md) { /* styles */ }

// Botones
@include button-variant($color-primary);

// Animaciones
@include transition(all);
@include hover-lift;

// Cards
@include card;
@include card-shadow;
```

## 🗂️ Estructura de Modelos

### Principales Entidades

```ruby
User
├── email, encrypted_password, role (:admin, :manager, :employee)
├── has_one :employee
└── devise modules

Employee
├── Datos personales: first_name, last_name, document_number, birth_date
├── Contacto: email, phone, mobile, address
├── Laborales: employee_number, hire_date, employment_status, salary
├── belongs_to :user, :position, :department, :manager (self), :office (optional)
└── has_many :subordinates (employees)

Department
├── name, description, active
├── has_many :positions, :employees
└── belongs_to :manager (User)

Position
├── title, description, level, salary_range
├── belongs_to :department
└── has_many :employees

Region
├── name, description, active
├── has_many :offices, :holidays
└── has_many :employees, through: :offices

Office (Sede)
├── name, description, address, active
├── belongs_to :region
└── has_many :employees

Holiday (Festivo)
├── name, date, active
├── belongs_to :region
└── scopes: upcoming, past, current_year, in_year

Segmentation (para filtros/grupos de empleados)
├── name, description, segmentation_type
└── has_many :segmentation_items

TimeOffPolicy
├── name, days_per_year, policy_type
└── reglas de acumulación
```

## 📝 Convenciones de Código

### Controllers

```ruby
class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def index
    authorize User
    @users = User.all.page(params[:page])
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
    authorize @user
  end
  
  def user_params
    params.require(:user).permit(:email, :role)
  end
end
```

### Políticas de Pundit

```ruby
class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end
  
  def update?
    user.admin? || record == user
  end
end
```

### Vistas ERB

**Usar ViewComponents para elementos reutilizables:**
```erb
<!-- Layout con componentes -->
<% if notice %>
  <%= render AlertComponent.new(type: :success) do %>
    <%= notice %>
  <% end %>
<% end %>

<div class="actions">
  <%= render ButtonComponent.new(variant: :primary, type: "submit") do %>
    Guardar
  <% end %>
  
  <%= render ButtonComponent.new(variant: :ghost, href: admin_users_path) do %>
    Cancelar
  <% end %>
</div>
```

**Combinar Tailwind + SCSS:**
```erb
<!-- Tailwind para layout, SCSS para componentes -->
<div class="flex items-center gap-4">
  <button class="btn btn--primary btn--lg">
    <!-- clase SCSS del component -->
  </button>
</div>
```

## 🎯 Reglas de Desarrollo

### Al crear nuevos componentes ViewComponent:

1. **NO usar namespaces** (clase directa, sin `module UI`)
2. Ubicar en `app/components/nombre_component.rb`
3. Template en `app/components/nombre_component.html.erb` (si es necesario)
4. Crear estilos correspondientes en `app/assets/stylesheets/components/_nombre.scss`
5. Importar SCSS en `app/assets/stylesheets/admin.scss`

### Al crear estilos SCSS:

1. Usar **variables** de `abstracts/_variables.scss` para colores, espaciados, tipografía
2. Crear **mixins** reutilizables en `abstracts/_mixins.scss` si el patrón se repite
3. Seguir nomenclatura **BEM** para clases CSS:
   ```scss
   .card { }
   .card__header { }
   .card__body { }
   .card--highlighted { }
   ```
4. Preferir composición sobre herencia (usar `@include` de mixins)

### Al trabajar con modelos:

1. Validaciones en el modelo
2. Scopes para queries comunes
3. Usar `belongs_to` con `optional: true` cuando sea apropiado
4. Enums para estados/tipos predefinidos
5. Callbacks solo cuando sean necesarios (evitar side effects)

### Al crear migraciones:

```ruby
class AddFieldToEmployees < ActiveRecord::Migration[7.2]
  def change
    add_column :employees, :field_name, :string
    add_index :employees, :field_name # si se busca por este campo
  end
end
```

## 🔒 Seguridad

- Todas las rutas admin protegidas con `authenticate_user!`
- Autorización con Pundit en todos los controllers
- Strong parameters en todos los formularios
- CSRF protection habilitado (Rails default)

## 🧪 Testing

- Tests ubicados en `test/` (Minitest)
- ViewComponents testeables con `ViewComponent::TestCase`
- System tests con Capybara + Selenium

## 📚 Documentación Adicional

- `docs/data_model.md`: Modelo de datos completo
- `docs/view_components.md`: Guía de componentes
- `docs/mejoras_aplicadas.md`: Historial de mejoras

## 💡 Notas Importantes

- **Docker volumes**: El código en el host se monta en `/rails` dentro del container
- **Asset compilation**: Ejecutar `docker-compose exec web bin/rails assets:precompile` después de cambios SCSS
- **Cache clearing**: `docker-compose exec web bin/rails tmp:clear` si hay problemas de cache
- **Zeitwerk autoloading**: Rails 7.2 es estricto con convenciones de nombres de archivos/clases
