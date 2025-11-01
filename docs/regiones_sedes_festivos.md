# Regiones, Sedes y Festivos

## Descripción

Módulo para la gestión de regiones geográficas, sedes corporativas y festivos por región.

## Modelos

### Region (Región)
Representa una región geográfica donde la empresa tiene presencia.

**Campos:**
- `name`: Nombre de la región (único, requerido)
- `description`: Descripción de la región
- `active`: Estado activo/inactivo (boolean)

**Relaciones:**
- `has_many :offices` - Sedes asociadas a la región
- `has_many :holidays` - Festivos de la región
- `has_many :employees, through: :offices` - Empleados en las sedes de la región

**Métodos útiles:**
- `offices_count`: Cantidad de sedes
- `holidays_count`: Cantidad de festivos
- `employees_count`: Cantidad de empleados
- `activate!` / `deactivate!`: Cambiar estado

### Office (Sede)
Representa una sede u oficina física de la empresa.

**Campos:**
- `name`: Nombre de la sede (requerido, único por región)
- `description`: Descripción de la sede
- `address`: Dirección completa
- `region_id`: Referencia a la región (requerido)
- `active`: Estado activo/inactivo (boolean)

**Relaciones:**
- `belongs_to :region` - Región a la que pertenece
- `has_many :employees` - Empleados asignados a esta sede

**Métodos útiles:**
- `employees_count`: Cantidad de empleados
- `full_name`: Nombre completo (incluye región)
- `activate!` / `deactivate!`: Cambiar estado

### Holiday (Festivo)
Representa un día festivo o no laborable.

**Campos:**
- `name`: Nombre del festivo (requerido)
- `date`: Fecha del festivo (requerido, única por región)
- `region_id`: Referencia a la región (requerido)
- `active`: Estado activo/inactivo (boolean)

**Relaciones:**
- `belongs_to :region` - Región a la que aplica el festivo

**Métodos útiles:**
- `past?`: Indica si el festivo ya pasó
- `upcoming?`: Indica si el festivo es futuro
- `formatted_date`: Fecha formateada con I18n
- `activate!` / `deactivate!`: Cambiar estado

**Scopes:**
- `upcoming`: Festivos futuros
- `past`: Festivos pasados
- `in_year(year)`: Festivos de un año específico
- `current_year`: Festivos del año actual
- `by_region(region_id)`: Filtrar por región

## Actualización de Employee

Se agregó la relación opcional con Office:

```ruby
belongs_to :office, optional: true
```

Esto permite asignar empleados a sedes específicas.

## Controllers

- `Admin::RegionsController` - CRUD de regiones
- `Admin::OfficesController` - CRUD de sedes
- `Admin::HolidaysController` - CRUD de festivos

Todos incluyen:
- Autorización con Pundit
- Paginación con Kaminari
- Acción `toggle_active` para activar/desactivar

## Vistas

### Regiones
- **Index**: Lista de regiones con estadísticas (sedes, festivos, empleados)
- **Show**: Detalle de región con sedes y festivos asociados
- **Form**: Crear/editar región

### Sedes
- **Index**: Lista de sedes con filtro por región
- **Show**: Detalle de sede con empleados asignados
- **Form**: Crear/editar sede

### Festivos
- **Index**: Lista de festivos con filtros por región y año
- **Show**: Detalle de festivo
- **Form**: Crear/editar festivo

## Políticas de Autorización

- **RegionPolicy**: Admin puede crear/editar/eliminar, Manager puede ver
- **OfficePolicy**: Admin puede crear/editar/eliminar, Manager puede ver
- **HolidayPolicy**: Todos pueden ver, solo Admin puede modificar

## Navegación

Se agregaron 3 nuevas opciones al sidebar del admin:
- 🌍 **Regiones**: Gestión de regiones
- 🏢 **Sedes**: Gestión de sedes
- 📅 **Festivos**: Gestión de festivos

## Rutas

```ruby
namespace :admin do
  resources :regions do
    member { patch :toggle_active }
  end
  
  resources :offices do
    member { patch :toggle_active }
  end
  
  resources :holidays do
    member { patch :toggle_active }
  end
end
```

## Seeds

El archivo `db/seeds/regions_offices_holidays.rb` crea datos de ejemplo:

- 4 regiones (Metropolitana, Norte, Sur, Centro)
- 6 sedes distribuidas entre las regiones
- Festivos nacionales para todas las regiones
- Festivos regionales específicos

## Uso

### Ejecutar migraciones

```bash
docker-compose exec web bin/rails db:migrate
```

### Cargar seeds

```bash
docker-compose exec web bin/rails db:seed
```

### Acceder a las secciones

Después de iniciar sesión como admin:
- `/admin/regions` - Gestión de regiones
- `/admin/offices` - Gestión de sedes
- `/admin/holidays` - Gestión de festivos

## Características Destacadas

1. **Festivos por Región**: Cada región puede tener sus propios festivos
2. **Sedes con Empleados**: Se puede asignar empleados a sedes específicas
3. **Filtros Inteligentes**: 
   - Festivos por año y región
   - Sedes por región
4. **Estados**: Todo puede activarse/desactivarse sin eliminar
5. **Validaciones**: No se puede eliminar una región con sedes asociadas
6. **Scopes útiles**: Festivos próximos, festivos pasados, por año, etc.

## Futuras Mejoras Posibles

- [ ] Asignación masiva de festivos a múltiples regiones
- [ ] Importar festivos desde calendario
- [ ] Reportes de distribución geográfica de empleados
- [ ] Mapa interactivo de sedes
- [ ] Notificaciones de festivos próximos
- [ ] Historial de cambios en festivos
