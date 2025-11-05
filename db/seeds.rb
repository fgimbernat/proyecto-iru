# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Starting seeds..."

# Clean existing data (development only)
if Rails.env.development?
  puts "Cleaning existing data..."
  Employee.destroy_all
  Position.destroy_all
  Department.destroy_all
  User.destroy_all
end

# Create Admin User
puts "Creating admin user..."
admin = User.create!(
  email: 'admin@iru.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :admin
)

# Create Departments
puts "Creating departments..."
departments = {
  it: Department.create!(name: 'Tecnología', description: 'Departamento de desarrollo y sistemas'),
  hr: Department.create!(name: 'Recursos Humanos', description: 'Gestión de personal'),
  sales: Department.create!(name: 'Ventas', description: 'Equipo comercial'),
  finance: Department.create!(name: 'Finanzas', description: 'Contabilidad y finanzas')
}

# Create Positions
puts "Creating positions..."
positions = {
  dev_jr: Position.create!(
    title: 'Desarrollador Junior',
    department: departments[:it],
    level: :junior,
    description: 'Desarrollador de software nivel junior',
    salary_range_min: 500000,
    salary_range_max: 800000
  ),
  dev_sr: Position.create!(
    title: 'Desarrollador Senior',
    department: departments[:it],
    level: :senior,
    description: 'Desarrollador de software nivel senior',
    salary_range_min: 1200000,
    salary_range_max: 1800000
  ),
  hr_manager: Position.create!(
    title: 'Gerente de RRHH',
    department: departments[:hr],
    level: :manager,
    description: 'Gerente del departamento de recursos humanos',
    salary_range_min: 1500000,
    salary_range_max: 2000000
  ),
  sales_rep: Position.create!(
    title: 'Representante de Ventas',
    department: departments[:sales],
    level: :mid,
    description: 'Ejecutivo de ventas',
    salary_range_min: 600000,
    salary_range_max: 1000000
  ),
  accountant: Position.create!(
    title: 'Contador',
    department: departments[:finance],
    level: :senior,
    description: 'Contador público',
    salary_range_min: 1000000,
    salary_range_max: 1400000
  )
}

# Create Employees
puts "Creating employees..."

# HR Manager
hr_manager_user = User.create!(
  email: 'manager@iru.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :manager
)

hr_manager = Employee.create!(
  first_name: 'María',
  last_name: 'González',
  document_type: :dni,
  document_number: '12345678',
  birth_date: Date.new(1985, 3, 15),
  gender: :female,
  marital_status: :married,
  email: 'manager@iru.com',
  phone: '341-1234567',
  mobile: '341-5555555',
  address: 'Av. Pellegrini 1234',
  city: 'Rosario',
  state: 'Santa Fe',
  postal_code: '2000',
  country: 'Argentina',
  hire_date: Date.new(2020, 1, 15),
  employment_status: :active,
  employment_type: :full_time,
  position: positions[:hr_manager],
  department: departments[:hr],
  salary: 1800000,
  currency: 'ARS',
  user: hr_manager_user
)

# Senior Developer
dev_sr_user = User.create!(
  email: 'dev.senior@iru.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :employee
)

Employee.create!(
  first_name: 'Carlos',
  last_name: 'Rodríguez',
  document_type: :dni,
  document_number: '23456789',
  birth_date: Date.new(1990, 7, 20),
  gender: :male,
  marital_status: :single,
  email: 'dev.senior@iru.com',
  phone: '341-2345678',
  mobile: '341-6666666',
  address: 'Bv. Oroño 567',
  city: 'Rosario',
  state: 'Santa Fe',
  postal_code: '2000',
  country: 'Argentina',
  hire_date: Date.new(2019, 6, 1),
  employment_status: :active,
  employment_type: :full_time,
  position: positions[:dev_sr],
  department: departments[:it],
  manager: hr_manager,
  salary: 1500000,
  currency: 'ARS',
  user: dev_sr_user
)

# Junior Developer
dev_jr_user = User.create!(
  email: 'dev.junior@iru.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :employee
)

Employee.create!(
  first_name: 'Ana',
  last_name: 'Martínez',
  document_type: :dni,
  document_number: '34567890',
  birth_date: Date.new(1995, 11, 10),
  gender: :female,
  marital_status: :single,
  email: 'dev.junior@iru.com',
  phone: '341-3456789',
  mobile: '341-7777777',
  address: 'Calle San Luis 890',
  city: 'Rosario',
  state: 'Santa Fe',
  postal_code: '2000',
  country: 'Argentina',
  hire_date: Date.new(2023, 3, 1),
  employment_status: :active,
  employment_type: :full_time,
  position: positions[:dev_jr],
  department: departments[:it],
  manager: hr_manager,
  salary: 700000,
  currency: 'ARS',
  user: dev_jr_user
)

# Sales Representative
sales_user = User.create!(
  email: 'sales@iru.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :employee
)

Employee.create!(
  first_name: 'Juan',
  last_name: 'Pérez',
  document_type: :dni,
  document_number: '45678901',
  birth_date: Date.new(1988, 5, 25),
  gender: :male,
  marital_status: :married,
  email: 'sales@iru.com',
  phone: '341-4567890',
  mobile: '341-8888888',
  address: 'Av. Francia 345',
  city: 'Rosario',
  state: 'Santa Fe',
  postal_code: '2000',
  country: 'Argentina',
  hire_date: Date.new(2021, 9, 15),
  employment_status: :active,
  employment_type: :full_time,
  position: positions[:sales_rep],
  department: departments[:sales],
  manager: hr_manager,
  salary: 850000,
  currency: 'ARS',
  user: sales_user
)

# Accountant
accountant_user = User.create!(
  email: 'accountant@iru.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :employee
)

Employee.create!(
  first_name: 'Laura',
  last_name: 'Fernández',
  document_type: :dni,
  document_number: '56789012',
  birth_date: Date.new(1987, 9, 30),
  gender: :female,
  marital_status: :divorced,
  email: 'accountant@iru.com',
  phone: '341-5678901',
  mobile: '341-9999999',
  address: 'Calle Córdoba 1111',
  city: 'Rosario',
  state: 'Santa Fe',
  postal_code: '2000',
  country: 'Argentina',
  hire_date: Date.new(2018, 2, 20),
  employment_status: :active,
  employment_type: :full_time,
  position: positions[:accountant],
  department: departments[:finance],
  manager: hr_manager,
  salary: 1300000,
  currency: 'ARS',
  user: accountant_user
)

puts "✅ Seeds completed successfully!"
puts "📊 Summary:"
puts "  - Users: #{User.count}"
puts "  - Departments: #{Department.count}"
puts "  - Positions: #{Position.count}"
puts "  - Employees: #{Employee.count}"
puts ""
puts "🔑 Login credentials:"
puts "  Admin: admin@iru.com / password123"
puts "  Manager: manager@iru.com / password123"
puts "  Employee: dev.senior@iru.com / password123"

# Load additional seeds
puts "\n📦 Loading additional seeds..."
load Rails.root.join('db', 'seeds', 'regions_offices_holidays.rb')
load Rails.root.join('db', 'seeds', 'policies.rb')
