import { Controller } from "@hotwired/stimulus"

// Controlador para filtrar sedes por región
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
    const selectedRegion = this.regionTarget.value
    
    // Limpiar opciones actuales excepto la primera (placeholder)
    this.officeTarget.innerHTML = '<option value="">Seleccionar sede</option>'
    
    if (selectedRegion) {
      // Habilitar select y ocultar hint
      this.officeTarget.disabled = false
      if (this.hasHintTarget) {
        this.hintTarget.style.display = 'none'
      }
      
      // Agregar oficinas de la región seleccionada
      const offices = this.officesValue[selectedRegion] || []
      offices.forEach((office) => {
        const option = document.createElement('option')
        option.value = office.id
        option.textContent = office.name
        
        // Mantener la selección si existe
        if (this.selectedOfficeValue && office.id.toString() === this.selectedOfficeValue) {
          option.selected = true
        }
        
        this.officeTarget.appendChild(option)
      })
    } else {
      // Deshabilitar select y mostrar hint
      this.officeTarget.disabled = true
      if (this.hasHintTarget) {
        this.hintTarget.style.display = 'block'
      }
    }
  }
}
