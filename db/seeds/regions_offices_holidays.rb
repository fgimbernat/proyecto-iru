# Seeds para Regiones, Sedes y Festivos
puts "🌍 Creando regiones..."

regions = [
  { name: 'Región Metropolitana', description: 'Capital y área metropolitana' },
  { name: 'Región Norte', description: 'Provincias del norte del país' },
  { name: 'Región Sur', description: 'Provincias del sur del país' },
  { name: 'Región Centro', description: 'Provincias del centro del país' }
]

created_regions = regions.map do |region_data|
  region = Region.find_or_create_by!(name: region_data[:name]) do |r|
    r.description = region_data[:description]
    r.active = true
  end
  puts "  ✓ #{region.name}"
  region
end

puts "\n🏢 Creando sedes..."

offices_data = [
  { region: 'Región Metropolitana', name: 'Oficina Central', address: 'Av. Principal 1234, Ciudad' },
  { region: 'Región Metropolitana', name: 'Sucursal Este', address: 'Calle Este 567, Ciudad' },
  { region: 'Región Norte', name: 'Oficina Norte Principal', address: 'Av. Norte 890, Ciudad Norte' },
  { region: 'Región Norte', name: 'Sucursal Norte 2', address: 'Calle Norte 123, Ciudad Norte' },
  { region: 'Región Sur', name: 'Oficina Sur', address: 'Av. Sur 456, Ciudad Sur' },
  { region: 'Región Centro', name: 'Oficina Centro', address: 'Calle Centro 789, Ciudad Centro' }
]

offices_data.each do |office_data|
  region = Region.find_by(name: office_data[:region])
  next unless region

  Office.find_or_create_by!(name: office_data[:name], region: region) do |office|
    office.address = office_data[:address]
    office.active = true
  end
  puts "  ✓ #{office_data[:name]} (#{region.name})"
end

puts "\n📅 Creando festivos para #{Date.current.year}..."

# Festivos nacionales (aplican a todas las regiones)
national_holidays = [
  { name: 'Año Nuevo', date: Date.new(Date.current.year, 1, 1) },
  { name: 'Día del Trabajo', date: Date.new(Date.current.year, 5, 1) },
  { name: 'Día de la Independencia', date: Date.new(Date.current.year, 7, 9) },
  { name: 'Navidad', date: Date.new(Date.current.year, 12, 25) }
]

created_regions.each do |region|
  national_holidays.each do |holiday_data|
    Holiday.find_or_create_by!(
      name: holiday_data[:name],
      date: holiday_data[:date],
      region: region
    ) do |holiday|
      holiday.active = true
    end
  end
  puts "  ✓ Festivos nacionales creados para #{region.name}"
end

# Festivos regionales específicos
regional_holidays = [
  { 
    region: 'Región Metropolitana', 
    name: 'Aniversario de la Ciudad', 
    date: Date.new(Date.current.year, 3, 15) 
  },
  { 
    region: 'Región Norte', 
    name: 'Fiesta Regional Norte', 
    date: Date.new(Date.current.year, 6, 20) 
  },
  { 
    region: 'Región Sur', 
    name: 'Día de la Región Sur', 
    date: Date.new(Date.current.year, 8, 10) 
  }
]

regional_holidays.each do |holiday_data|
  region = Region.find_by(name: holiday_data[:region])
  next unless region

  Holiday.find_or_create_by!(
    name: holiday_data[:name],
    date: holiday_data[:date],
    region: region
  ) do |holiday|
    holiday.active = true
  end
  puts "  ✓ #{holiday_data[:name]} (#{region.name})"
end

puts "\n✨ Seeds de regiones, sedes y festivos completados!"
puts "📊 Resumen:"
puts "  - Regiones: #{Region.count}"
puts "  - Sedes: #{Office.count}"
puts "  - Festivos: #{Holiday.count}"
