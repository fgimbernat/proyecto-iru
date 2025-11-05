# frozen_string_literal: true

# Seeds para PolicyTypes y Policies
puts '🌱 Creando PolicyTypes...'

vacation_type = PolicyType.find_or_create_by!(name: 'Vacaciones') do |pt|
  pt.unit = 'days'
  pt.active = true
end

study_type = PolicyType.find_or_create_by!(name: 'Días de estudio') do |pt|
  pt.unit = 'days'
  pt.active = true
end

sick_leave_type = PolicyType.find_or_create_by!(name: 'Licencia por enfermedad') do |pt|
  pt.unit = 'days'
  pt.active = true
end

personal_hours_type = PolicyType.find_or_create_by!(name: 'Horas personales') do |pt|
  pt.unit = 'hours'
  pt.active = true
end

puts "  ✅ Creados #{PolicyType.count} tipos de políticas"

puts '🌱 Creando Policies de ejemplo...'

# Política de Vacaciones Estándar
Policy.find_or_create_by!(name: 'Vacaciones Anuales Estándar', policy_type: vacation_type) do |policy|
  policy.description = 'Política estándar de vacaciones anuales para todos los empleados'
  
  # Derecho a prestación
  policy.entitlement_type = 'basic_annual'
  policy.annual_entitlement = 15.0
  
  # Periodo de actividad
  policy.period_type = 'jan_dec'
  
  # Acumulación
  policy.accrual_frequency = 'monthly'
  policy.accrual_timing = 'start_of_cycle'
  
  # Visualización
  policy.balance_precision = 'decimals'
  
  # Prorrateo
  policy.proration_calculation = 'working_days'
  policy.grant_on_hire = true
  policy.grant_on_termination = true
  
  # Remanente
  policy.enable_carryover = true
  policy.carryover_limit = 5
  policy.carryover_expires = true
  policy.carryover_expiration_amount = 3
  policy.carryover_expiration_unit = 'months'
  
  # Saldo máximo
  policy.enable_max_balance = true
  policy.max_balance = 20
  
  # Saldo mínimo
  policy.enable_min_balance = false
  policy.min_balance = 0
  
  # Solicitudes de empleados
  policy.min_advance_days = 7.0
  policy.allow_retroactive = false
  policy.allow_half_day = true
  policy.min_request_period = 0.5
  policy.max_request_period = 15.0
  
  # Bloqueo nuevas contrataciones
  policy.block_new_hire_requests = true
  policy.new_hire_block_days = 90
  policy.new_hire_block_unit = 'days'
  
  # Bloqueo general
  policy.block_employee_requests = false
  
  # Archivo adjunto
  policy.attachment_requirement = 'optional'
  
  # Instrucciones
  policy.instructions = 'Las vacaciones deben solicitarse con al menos 7 días de anticipación.'
  
  policy.active = true
end

# Política de Días de Estudio
Policy.find_or_create_by!(name: 'Día de Estudio', policy_type: study_type) do |policy|
  policy.description = 'Días otorgados para estudios formales'
  
  # Derecho a prestación
  policy.entitlement_type = 'basic_annual'
  policy.annual_entitlement = 0.0
  
  # Periodo de actividad
  policy.period_type = 'jan_dec'
  
  # Acumulación
  policy.accrual_frequency = 'annual'
  policy.accrual_timing = 'start_of_cycle'
  
  # Visualización
  policy.balance_precision = 'decimals'
  
  # Prorrateo
  policy.proration_calculation = 'working_days'
  policy.grant_on_hire = false
  policy.grant_on_termination = false
  
  # Sin remanente
  policy.enable_carryover = false
  policy.carryover_limit = 0
  
  # Sin límites de saldo
  policy.enable_max_balance = false
  policy.enable_min_balance = false
  
  # Solicitudes de empleados
  policy.min_advance_days = 1.0
  policy.allow_retroactive = false
  policy.allow_half_day = true
  policy.min_request_period = 1.0
  policy.max_request_period = 1.0
  
  # Bloqueo nuevas contrataciones
  policy.block_new_hire_requests = true
  policy.new_hire_block_days = 1
  policy.new_hire_block_unit = 'days'
  
  # Bloqueo general
  policy.block_employee_requests = false
  
  # Archivo adjunto requerido
  policy.attachment_requirement = 'required'
  
  # Instrucciones
  policy.instructions = 'Ej: Facilitar nota del médico si la enfermedad dura más de 2 días.'
  
  policy.active = true
end

# Política de Horas Personales
Policy.find_or_create_by!(name: 'Horas Personales Mensuales', policy_type: personal_hours_type) do |policy|
  policy.description = 'Horas personales que se pueden tomar cada mes'
  
  # Derecho a prestación
  policy.entitlement_type = 'basic_annual'
  policy.annual_entitlement = 24.0 # 2 horas por mes
  
  # Periodo de actividad
  policy.period_type = 'jan_dec'
  
  # Acumulación mensual
  policy.accrual_frequency = 'monthly'
  policy.accrual_timing = 'start_of_cycle'
  
  # Visualización
  policy.balance_precision = 'decimals'
  
  # Prorrateo
  policy.proration_calculation = 'working_days'
  policy.grant_on_hire = true
  policy.grant_on_termination = false
  
  # Sin remanente
  policy.enable_carryover = false
  policy.carryover_limit = 0
  
  # Saldo máximo
  policy.enable_max_balance = true
  policy.max_balance = 10
  
  # Saldo mínimo negativo permitido
  policy.enable_min_balance = true
  policy.min_balance = -2
  
  # Solicitudes de empleados
  policy.min_advance_days = 0.5
  policy.allow_retroactive = true
  policy.allow_half_day = true
  policy.min_request_period = 0.5
  policy.max_request_period = 7.5
  
  # Sin bloqueo para nuevas contrataciones
  policy.block_new_hire_requests = false
  
  # Bloqueo general
  policy.block_employee_requests = false
  
  # Archivo adjunto
  policy.attachment_requirement = 'not_required'
  
  # Instrucciones
  policy.instructions = 'Las horas personales se acumulan mensualmente y tienen un límite máximo.'
  
  policy.active = true
end

# Política de Licencia Ilimitada (ejemplo)
Policy.find_or_create_by!(name: 'Vacaciones Ilimitadas - Seniors', policy_type: vacation_type) do |policy|
  policy.description = 'Política de vacaciones ilimitadas para empleados senior'
  
  # Derecho a prestación
  policy.entitlement_type = 'unlimited'
  policy.annual_entitlement = 0.0
  
  # Periodo de actividad
  policy.period_type = 'jan_dec'
  
  # Acumulación (no aplica para ilimitado, pero es required)
  policy.accrual_frequency = 'annual'
  policy.accrual_timing = 'start_of_cycle'
  
  # Visualización
  policy.balance_precision = 'rounded'
  
  # Prorrateo
  policy.proration_calculation = 'working_days'
  policy.grant_on_hire = false
  policy.grant_on_termination = false
  
  # Sin remanente
  policy.enable_carryover = false
  policy.carryover_limit = 0
  
  # Sin límites de saldo
  policy.enable_max_balance = false
  policy.enable_min_balance = false
  
  # Solicitudes de empleados
  policy.min_advance_days = 14.0
  policy.allow_retroactive = false
  policy.allow_half_day = false
  policy.min_request_period = 1.0
  policy.max_request_period = 30.0
  
  # Sin bloqueo para nuevas contrataciones
  policy.block_new_hire_requests = false
  
  # Sin bloqueo general
  policy.block_employee_requests = false
  
  # Archivo adjunto
  policy.attachment_requirement = 'optional'
  
  # Instrucciones
  policy.instructions = 'Política de confianza para empleados senior. Solicitar con 14 días de anticipación.'
  
  policy.active = true
end

puts "  ✅ Creadas #{Policy.count} políticas"
puts '✨ Seeds de PolicyTypes y Policies completados'
