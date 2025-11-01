# Comandos para ejecutar las nuevas funcionalidades

## 1. Ejecutar las migraciones
```powershell
docker-compose exec web bin/rails db:migrate
```

## 2. Cargar los seeds (opcional - solo en desarrollo)
```powershell
docker-compose exec web bin/rails db:seed
```

## 3. Reiniciar el servidor (si es necesario)
```powershell
docker-compose restart web
```

## 4. Ver logs
```powershell
docker-compose logs -f web
```

## Verificar que todo funciona

1. Accede a la aplicación en http://localhost:3000
2. Inicia sesión como admin (admin@iru.com / password123)
3. Verifica que aparezcan las nuevas opciones en el sidebar:
   - Regiones
   - Sedes
   - Festivos

## Resumen de lo creado

✅ **Migraciones** (4):
- `create_regions.rb` - Tabla de regiones
- `create_offices.rb` - Tabla de sedes
- `create_holidays.rb` - Tabla de festivos
- `add_office_to_employees.rb` - Relación empleado-sede

✅ **Modelos** (3):
- `Region` - Con validaciones y relaciones
- `Office` - Con validaciones y relaciones
- `Holiday` - Con validaciones, scopes y relaciones

✅ **Políticas** (3):
- `RegionPolicy` - Autorización para regiones
- `OfficePolicy` - Autorización para sedes
- `HolidayPolicy` - Autorización para festivos

✅ **Controllers** (3):
- `Admin::RegionsController` - CRUD completo
- `Admin::OfficesController` - CRUD completo
- `Admin::HolidaysController` - CRUD completo

✅ **Vistas** (15 archivos):
- Regiones: index, show, new, edit, _form
- Sedes: index, show, new, edit, _form
- Festivos: index, show, new, edit, _form

✅ **Rutas**: Agregadas al namespace admin

✅ **Navegación**: Sidebar actualizado con 3 nuevas opciones

✅ **Seeds**: Datos de ejemplo para probar

✅ **Documentación**: `docs/regiones_sedes_festivos.md`
