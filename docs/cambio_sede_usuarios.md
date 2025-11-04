# Cambio: Agregado campo de Sede/Office en formulario de usuarios

## Fecha: 4 de noviembre de 2025

## Descripción
Se ha agregado la funcionalidad para asignar una Sede (Office) a los usuarios en el formulario de creación/edición, con un filtro dinámico por Región.

## Archivos modificados

### 1. Controller: `app/controllers/admin/users_controller.rb`
- **Método `load_form_data`**: Agregadas variables `@regions` y `@offices` para cargar las regiones activas y sedes activas con sus regiones.
- **Método `user_params`**: Agregado el parámetro `:office_id` en `employee_attributes` para permitir guardar la sede asignada.

```ruby
def load_form_data
  @regions = Region.where(active: true).order(:name)
  @offices = Office.where(active: true).includes(:region).order(:name)
end

# En employee_attributes:
:office_id,
```

### 2. Vista: `app/views/admin/users/_form.html.erb`
- **Acordeón "Trabajo"**: Agregados dos nuevos campos interactivos:
  - **Región (filtro)**: Select que permite filtrar las sedes por región
  - **Sede**: Select dinámico que muestra solo las sedes de la región seleccionada
  
- **Funcionalidad Alpine.js**: 
  - Filtra las sedes según la región seleccionada
  - Deshabilita el select de sedes hasta que se seleccione una región
  - Mantiene la sede previamente asignada al editar

```erb
<div x-data="{ 
  selectedRegion: '<%= ef.object.office&.region_id || '' %>',
  offices: <%= @offices.group_by(&:region_id).transform_values { |offices| offices.map { |o| { id: o.id, name: o.name } } }.to_json.html_safe %>,
  get filteredOffices() {
    return this.selectedRegion ? (this.offices[this.selectedRegion] || []) : [];
  }
}">
  <!-- Campo Región (filtro) -->
  <!-- Campo Sede (dinámico) -->
</div>
```

### 3. Vista: `app/views/admin/users/show.html.erb`
- **Sección "Información Laboral"**: Agregado campo para mostrar la sede asignada junto con el nombre de la región entre paréntesis.

```erb
<% if @user.employee.office %>
  <div>
    <dt class="text-sm font-medium text-gray-500">Sede</dt>
    <dd class="mt-1 text-sm text-gray-900">
      <%= @user.employee.office.name %>
      <span class="text-gray-500">(<%= @user.employee.office.region.name %>)</span>
    </dd>
  </div>
<% end %>
```

## Características implementadas

1. **Filtrado dinámico**: Las sedes se filtran automáticamente según la región seleccionada usando Alpine.js
2. **Validación UX**: El campo de sede se deshabilita hasta que se seleccione una región
3. **Persistencia**: Al editar un usuario, se mantienen seleccionadas la región y sede previamente asignadas
4. **Visualización**: En la vista de detalle del usuario se muestra la sede con su región correspondiente

## Relaciones de base de datos utilizadas

```
Employee
  └── belongs_to :office (optional: true)
        └── belongs_to :region

Region
  └── has_many :offices

Office
  └── belongs_to :region
  └── has_many :employees
```

## Notas técnicas

- El campo `office_id` es **opcional** en el modelo Employee
- Se cargan solo regiones y sedes activas (`active: true`)
- Alpine.js se utiliza para la interactividad del formulario sin necesidad de JavaScript adicional
- Los datos de sedes se serializan a JSON en el HTML para uso por Alpine.js

## Testing recomendado

1. Crear un nuevo usuario y asignar una sede
2. Editar un usuario existente y cambiar de sede
3. Verificar que el filtro de región funciona correctamente
4. Verificar que la sede se muestra en la vista de detalle del usuario
5. Probar con usuarios que no tienen sede asignada (opcional)
