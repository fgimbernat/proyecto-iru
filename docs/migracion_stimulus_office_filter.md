# Migración de Alpine.js a Stimulus para Filtrado de Sedes

## Fecha: 4 de noviembre de 2025

## Motivación
Se migró la funcionalidad de filtrado de sedes por región de Alpine.js a **Stimulus** (el framework JavaScript recomendado por Rails) para:
- ✅ Mejor organización del código JavaScript
- ✅ Reutilización del controlador en otros formularios
- ✅ Separación de responsabilidades (JavaScript fuera de las vistas)
- ✅ Mayor mantenibilidad y testabilidad
- ✅ Mejor integración con el ecosistema Rails/Hotwire

## Estructura Implementada

### 1. Controlador Stimulus
**Ubicación**: `app/javascript/controllers/office_filter_controller.js`

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["region", "office", "hint"]
  static values = {
    offices: Object,
    selectedOffice: String
  }

  connect() {
    this.updateOffices()
  }

  updateOffices() {
    // Lógica de filtrado
  }
}
```

**Características**:
- **Targets**: Define los elementos HTML que el controlador manipula
  - `region`: Select de regiones
  - `office`: Select de sedes
  - `hint`: Mensaje de ayuda
  
- **Values**: Datos pasados desde el HTML
  - `offices`: Objeto JSON con sedes agrupadas por región
  - `selectedOffice`: ID de la sede preseleccionada (al editar)

- **Métodos**:
  - `connect()`: Se ejecuta cuando el controlador se conecta al DOM
  - `updateOffices()`: Actualiza las opciones de sedes según región seleccionada

### 2. Vista Actualizada
**Ubicación**: `app/views/admin/users/_form_trabajo.html.erb`

```erb
<div 
  data-controller="office-filter"
  data-office-filter-offices-value="<%= ... JSON ... %>"
  data-office-filter-selected-office-value="<%= ef.object.office_id %>">
  
  <!-- Select de región -->
  <%= select_tag :region_filter, ...,
      data: { 
        office_filter_target: "region",
        action: "change->office-filter#updateOffices"
      } %>
  
  <!-- Select de sedes -->
  <%= ef.select :office_id, ...,
      data: { office_filter_target: "office" } %>
  
  <!-- Mensaje de ayuda -->
  <p data-office-filter-target="hint">...</p>
</div>
```

## Convenciones de Stimulus

### Naming Conventions
- **Controlador**: `office_filter_controller.js` → `data-controller="office-filter"`
- **Target**: `static targets = ["region"]` → `data-office-filter-target="region"`
- **Value**: `static values = { offices: Object }` → `data-office-filter-offices-value="..."`
- **Action**: `change->office-filter#updateOffices`
  - `change`: evento del DOM
  - `office-filter`: nombre del controlador
  - `updateOffices`: método del controlador

### Convención de Kebab-case
- Archivo: `office_filter_controller.js` (snake_case)
- HTML: `office-filter` (kebab-case)
- JavaScript: `officeFilter` (camelCase)

Stimulus convierte automáticamente entre estos formatos.

## Comparación: Antes vs Después

### ❌ Antes (Alpine.js en la vista)
```erb
<div x-data="{ ... código JS ... }">
  <select x-model="selectedRegion" @change="...">
  ...
</div>
```

**Problemas**:
- JavaScript mezclado con HTML
- Difícil de reutilizar
- Difícil de testear
- No sigue convenciones Rails

### ✅ Después (Stimulus con controlador dedicado)
```erb
<div data-controller="office-filter" data-office-filter-offices-value="...">
  <select data-office-filter-target="region" data-action="change->office-filter#updateOffices">
  ...
</div>
```

**Ventajas**:
- JavaScript separado en su propio archivo
- Reutilizable en otros formularios
- Testable unitariamente
- Sigue convenciones Rails/Hotwire
- Auto-loading automático

## Funcionamiento

1. **Al cargar la página**:
   - Stimulus detecta `data-controller="office-filter"`
   - Instancia el controlador
   - Ejecuta `connect()` que llama a `updateOffices()`
   - Si hay región preseleccionada, carga las sedes correspondientes

2. **Al cambiar región**:
   - El evento `change` se dispara
   - Stimulus ejecuta `updateOffices()` vía `data-action`
   - El método actualiza las opciones del select de sedes

3. **Al editar usuario**:
   - La región y sede preseleccionadas se pasan como `data-*-value`
   - El controlador las usa para restaurar el estado

## Reutilización

Este controlador puede reutilizarse en cualquier formulario que necesite filtrado dependiente:

```erb
<!-- Ejemplo: filtrar ciudades por provincia -->
<div 
  data-controller="office-filter"
  data-office-filter-offices-value="<%= cities_by_province.to_json %>">
  
  <select data-office-filter-target="region" 
          data-action="change->office-filter#updateOffices">
    <!-- provincias -->
  </select>
  
  <select data-office-filter-target="office">
    <!-- ciudades -->
  </select>
</div>
```

## Testing (Futuro)

Con Stimulus, el controlador puede testearse con Jest:

```javascript
import { Application } from "@hotwired/stimulus"
import OfficeFilterController from "./office_filter_controller"

describe("OfficeFilterController", () => {
  it("filters offices by region", () => {
    // Test logic
  })
})
```

## Archivos Modificados

1. **Creado**: `app/javascript/controllers/office_filter_controller.js`
2. **Modificado**: `app/views/admin/users/_form_trabajo.html.erb`

## Compatibilidad

- ✅ Rails 7.2+
- ✅ Stimulus 3.x
- ✅ Hotwire/Turbo
- ✅ Todos los navegadores modernos

## Próximos Pasos Recomendados

1. Aplicar el mismo patrón a otros filtros dependientes del sistema
2. Escribir tests para el controlador Stimulus
3. Documentar otros controladores Stimulus existentes
4. Eliminar Alpine.js si no se usa en otras partes

## Referencias

- [Stimulus Handbook](https://stimulus.hotwired.dev/handbook/introduction)
- [Stimulus Best Practices](https://stimulus.hotwired.dev/handbook/installing)
- [Rails + Stimulus Tutorial](https://railsnotes.xyz/blog/stimulus-js-tutorial-for-rails-developers)
