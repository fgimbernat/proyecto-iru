# Script para crear/actualizar segmentaciones del sistema

puts "Configurando segmentaciones del sistema..."

# Definir las segmentaciones del sistema
system_segmentations = [
  { name: 'Área', visibility: 'all' },
  { name: 'Jerarquía', visibility: 'all' },
  { name: 'Ubicación', visibility: 'all' }
]

system_segmentations.each do |seg_data|
  segmentation = Segmentation.find_or_initialize_by(name: seg_data[:name])
  segmentation.visibility = seg_data[:visibility]
  segmentation.is_system = true
  
  if segmentation.save
    puts "✅ Segmentación del sistema '#{segmentation.name}' configurada"
  else
    puts "❌ Error al configurar '#{segmentation.name}': #{segmentation.errors.full_messages.join(', ')}"
  end
end

puts "\n📊 Total de segmentaciones del sistema: #{Segmentation.system_segmentations.count}"
puts "📊 Total de segmentaciones personalizadas: #{Segmentation.custom_segmentations.count}"
