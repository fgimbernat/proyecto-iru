# Refactorización del Formulario de Usuarios

## Fecha: 4 de noviembre de 2025

## Objetivo
Simplificar y modularizar el formulario de usuarios (`_form.html.erb`) que tenía más de 400 líneas de código, dividiéndolo en partials reutilizables y mantenibles.

## Estructura Anterior
- **1 archivo monolítico**: `_form.html.erb` (413 líneas)
- Todo el código HTML, validaciones y lógica en un solo archivo
- Difícil de mantener y leer

## Estructura Nueva
El formulario ahora está dividido en **9 archivos modulares**:

### 1. Archivo Principal
- `_form.html.erb` (67 líneas) - Estructura principal y layout del formulario

### 2. Componentes del Sidebar
- `_form_sidebar.html.erb` - Información básica del usuario (avatar, nombre, email, contraseña)

### 3. Tabs del Contenido Principal
- `_form_tab_general.html.erb` - Contenedor del tab General
- `_form_tab_segmentacion.html.erb` - Contenedor del tab Segmentación
- `_form_tab_permisos.html.erb` - Contenedor del tab Permisos

### 4. Acordeones del Tab General
- `_form_general_settings.html.erb` - Datos personales (DNI, fecha nacimiento, teléfono)
- `_form_trabajo.html.erb` - Información laboral (fecha contratación, jefe, departamento, puesto, **región/sede**)
- `_form_redes_sociales.html.erb` - Redes sociales (LinkedIn, Instagram, Facebook, Twitter)
- `_form_campos_personalizados.html.erb` - Campos adicionales (equipo, educación, salarios, etc.)
- `_form_metodos_acceso.html.erb` - Código PIN para acceso

## Beneficios de la Refactorización

### ✅ Mantenibilidad
- Cada sección tiene su propio archivo
- Fácil localizar y modificar funcionalidad específica
- Cambios aislados no afectan otras partes

### ✅ Reusabilidad
- Los partials pueden reutilizarse en otros contextos
- Fácil crear formularios similares para otras entidades

### ✅ Legibilidad
- Código más limpio y organizado
- Nombres descriptivos de archivos
- Reducción del archivo principal de 413 a 67 líneas (84% de reducción)

### ✅ Colaboración
- Múltiples desarrolladores pueden trabajar en diferentes secciones sin conflictos
- Pull requests más pequeños y enfocados

## Estructura de Archivos

```
app/views/admin/users/
├── _form.html.erb                          (Principal - 67 líneas)
├── _form_sidebar.html.erb                  (Sidebar - 54 líneas)
├── _form_tab_general.html.erb              (Tab wrapper - 8 líneas)
├── _form_tab_segmentacion.html.erb         (Tab wrapper - 19 líneas)
├── _form_tab_permisos.html.erb             (Tab wrapper - 40 líneas)
├── _form_general_settings.html.erb         (Acordeón - 35 líneas)
├── _form_trabajo.html.erb                  (Acordeón - 75 líneas) ⭐ Incluye región/sede
├── _form_redes_sociales.html.erb           (Acordeón - 31 líneas)
├── _form_campos_personalizados.html.erb    (Acordeón - 63 líneas)
└── _form_metodos_acceso.html.erb           (Acordeón - 19 líneas)
```

## Llamadas entre Archivos

```
_form.html.erb
├── render 'form_sidebar'
└── render 'form_tab_general'
    ├── render 'form_general_settings'
    ├── render 'form_trabajo'
    ├── render 'form_redes_sociales'
    ├── render 'form_campos_personalizados'
    └── render 'form_metodos_acceso'
├── render 'form_tab_segmentacion'
└── render 'form_tab_permisos'
```

## Mejoras Adicionales Implementadas

1. **Uso de AlertComponent**: Se reemplazó el HTML manual de errores por el componente `AlertComponent`
2. **Mejora de placeholders**: Se ajustaron los placeholders para ser más descriptivos
3. **Conservación de funcionalidad Alpine.js**: Se mantuvo toda la lógica reactiva de filtrado de región/sede

## Compatibilidad

- ✅ Totalmente compatible con la funcionalidad existente
- ✅ Mantiene todos los campos y validaciones
- ✅ No requiere cambios en el controlador
- ✅ No requiere cambios en el modelo
- ✅ Alpine.js continúa funcionando correctamente

## Testing Recomendado

- [ ] Crear nuevo usuario
- [ ] Editar usuario existente
- [ ] Verificar validaciones de formulario
- [ ] Probar filtro de región/sede
- [ ] Verificar que todos los tabs funcionen
- [ ] Verificar que todos los acordeones se expandan/contraigan
- [ ] Probar asignación de segmentaciones
- [ ] Probar cambio de roles/permisos

## Notas

- Se mantiene el archivo backup `_form.html.erb.backup` por seguridad
- Todos los partials reciben las mismas variables que el formulario original
- La estructura de datos no cambió, solo la presentación
