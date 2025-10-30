# Modelo de Datos - Sistema de Gestión de RRHH

## Entidades Principales

### 1. User (Usuario del sistema)
```ruby
- email: string
- encrypted_password: string
- role: enum [:admin, :manager, :employee]
- employee_id: references (one-to-one con Employee)
```

### 2. Department (Departamento)
```ruby
- name: string (ej: "Recursos Humanos", "IT", "Ventas")
- description: text
- manager_id: references User (opcional)
- active: boolean
```

### 3. Position (Puesto/Cargo)
```ruby
- title: string (ej: "Desarrollador Senior", "Gerente de Ventas")
- description: text
- department_id: references Department
- level: enum [:entry, :junior, :mid, :senior, :lead, :manager, :director]
- salary_range_min: decimal
- salary_range_max: decimal
```

### 4. Employee (Empleado)
```ruby
# Datos personales
- first_name: string
- last_name: string
- document_type: enum [:dni, :passport, :other]
- document_number: string (único)
- birth_date: date
- gender: enum [:male, :female, :other, :prefer_not_to_say]
- marital_status: enum [:single, :married, :divorced, :widowed]

# Contacto
- email: string
- phone: string
- mobile: string
- address: text
- city: string
- state: string
- postal_code: string
- country: string (default: "Argentina")

# Datos laborales
- employee_number: string (único, autogenerado)
- hire_date: date
- termination_date: date (nullable)
- employment_status: enum [:active, :on_leave, :terminated, :suspended]
- employment_type: enum [:full_time, :part_time, :contractor, :intern]
- position_id: references Position
- department_id: references Department
- manager_id: references Employee (self-referential)
- salary: decimal
- currency: string (default: "ARS")

# Sistema
- user_id: references User (one-to-one)
- created_at: datetime
- updated_at: datetime
```

## Relaciones

```
User
├── has_one: Employee
└── role: [:admin, :manager, :employee]

Department
├── has_many: Positions
├── has_many: Employees
└── belongs_to: Manager (User)

Position
├── belongs_to: Department
└── has_many: Employees

Employee
├── belongs_to: User
├── belongs_to: Position
├── belongs_to: Department
├── belongs_to: Manager (Employee)
└── has_many: Subordinates (Employees)
```

## Futuras Extensiones

### Gestión de Tiempo
- **Attendance** (Asistencia): check-in, check-out, trabajo remoto
- **TimeOff** (Ausencias): vacaciones, licencias, permisos
- **Holidays** (Feriados): días no laborables

### Documentos y Procesos
- **Document** (Documentos): contratos, certificados, evaluaciones
- **PerformanceReview** (Evaluaciones de desempeño)
- **Training** (Capacitaciones)

### Nómina
- **Payroll** (Nómina): salarios, bonos, deducciones
- **Benefit** (Beneficios): obra social, seguro, etc.

## Índices Importantes

```ruby
# Para búsquedas rápidas
- employees: employee_number (unique)
- employees: document_number (unique)
- employees: email (unique)
- employees: employment_status
- employees: department_id
- employees: position_id
```

## Validaciones Clave

```ruby
Employee:
- Presencia: first_name, last_name, document_number, hire_date
- Unicidad: employee_number, document_number, email
- Formato: email válido
- Lógica: hire_date <= termination_date (si existe)
```
