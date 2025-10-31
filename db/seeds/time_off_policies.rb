# Seeds para Time Off Policies

puts "Creando políticas de ausencias..."

TimeOffPolicy.create!([
  {
    name: "Vacaciones",
    description: "Días de vacaciones anuales pagadas",
    policy_type: :vacation,
    days_per_year: 14,
    requires_approval: true,
    active: true,
    icon: "🏖️",
    color: "blue"
  },
  {
    name: "Descanso médico",
    description: "Licencia por enfermedad o atención médica",
    policy_type: :sick_leave,
    days_per_year: 10,
    requires_approval: false,
    active: true,
    icon: "🏥",
    color: "red"
  },
  {
    name: "Días de estudio",
    description: "Días para capacitación o estudios",
    policy_type: :study_leave,
    days_per_year: 5,
    requires_approval: true,
    active: true,
    icon: "📚",
    color: "purple"
  },
  {
    name: "Licencia por maternidad",
    description: "Licencia por maternidad",
    policy_type: :maternity_leave,
    days_per_year: 90,
    requires_approval: true,
    active: true,
    icon: "👶",
    color: "pink"
  },
  {
    name: "Licencia por paternidad",
    description: "Licencia por paternidad",
    policy_type: :paternity_leave,
    days_per_year: 15,
    requires_approval: true,
    active: true,
    icon: "👨‍👶",
    color: "indigo"
  },
  {
    name: "Teletrabajo",
    description: "Días de trabajo remoto",
    policy_type: :remote_work,
    days_per_year: 52,
    requires_approval: true,
    active: true,
    icon: "🏠",
    color: "yellow"
  },
  {
    name: "Día personal",
    description: "Días personales para asuntos propios",
    policy_type: :personal_day,
    days_per_year: 3,
    requires_approval: true,
    active: true,
    icon: "🧘",
    color: "green"
  }
])

puts "✅ #{TimeOffPolicy.count} políticas de ausencias creadas"
