import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    itemId: Number,
    itemName: String
  }

  connect() {
    // Controlador conectado
  }

  async openModal(event) {
    const itemId = event.currentTarget.dataset.itemId
    const itemName = event.currentTarget.dataset.itemName
    
    this.itemIdValue = itemId
    this.itemNameValue = itemName
    
    // Buscar el modal en el DOM
    const modal = document.querySelector('[data-segmentation-users-target="modal"]')
    if (!modal) {
      console.error("Modal not found in DOM")
      return
    }
    
    // Mover modal al final del body para evitar problemas de z-index
    document.body.appendChild(modal)
    
    // Mostrar modal
    modal.style.display = 'flex'
    document.body.style.overflow = 'hidden'
    
    // Actualizar título
    const itemNameElement = document.querySelector('[data-segmentation-users-target="itemName"]')
    if (itemNameElement) {
      itemNameElement.textContent = itemName
    }
    
    // Cargar usuarios
    await this.loadUsers()
  }

  closeModal() {
    const modal = document.querySelector('[data-segmentation-users-target="modal"]')
    if (modal) {
      modal.style.display = 'none'
    }
    document.body.style.overflow = 'auto'
    
    const searchInput = document.querySelector('[data-segmentation-users-target="searchInput"]')
    if (searchInput) {
      searchInput.value = ''
    }
    
    const availableList = document.querySelector('[data-segmentation-users-target="availableList"]')
    if (availableList) {
      availableList.innerHTML = ''
    }
  }

  stopPropagation(event) {
    event.stopPropagation()
  }

  async loadUsers() {
    const loadingState = document.querySelector('[data-segmentation-users-target="loadingState"]')
    const assignedList = document.querySelector('[data-segmentation-users-target="assignedList"]')
    
    if (loadingState) loadingState.style.display = 'flex'
    if (assignedList) assignedList.style.display = 'none'
    
    try {
      const response = await fetch(`/admin/segmentation/items/${this.itemIdValue}/users`)
      const data = await response.json()
      
      this.assignedUsers = data.assigned_users
      this.availableUsers = data.available_users
      
      this.renderAssignedUsers()
      
      if (loadingState) loadingState.style.display = 'none'
      if (assignedList) assignedList.style.display = 'block'
    } catch (error) {
      console.error('Error loading users:', error)
      if (loadingState) loadingState.style.display = 'none'
      if (assignedList) assignedList.style.display = 'block'
    }
  }

  renderAssignedUsers() {
    const assignedList = document.querySelector('[data-segmentation-users-target="assignedList"]')
    if (!assignedList) return
    
    // Actualizar contador
    const countElement = document.getElementById('assigned-count')
    if (countElement) {
      countElement.textContent = this.assignedUsers.length
    }

    if (this.assignedUsers.length === 0) {
      assignedList.innerHTML = `
        <div class="text-center py-12">
          <div class="inline-flex items-center justify-center w-16 h-16 bg-gray-100 rounded-full mb-3">
            <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
            </svg>
          </div>
          <p class="text-sm font-medium text-gray-900 mb-1">No hay usuarios asignados</p>
          <p class="text-xs text-gray-500">Busca usuarios para asignarlos a este item</p>
        </div>
      `
    } else {
      assignedList.innerHTML = this.assignedUsers.map(user => `
        <div class="flex items-center justify-between p-3 border border-gray-200 rounded-lg hover:bg-gray-50 transition-all group">
          <div class="flex items-center min-w-0 flex-1">
            <div class="w-9 h-9 bg-gradient-to-br from-blue-400 to-blue-600 rounded-full flex items-center justify-center text-white text-xs font-semibold mr-3 shadow-sm">
              <span>${this.getInitials(user.name)}</span>
            </div>
            <div class="min-w-0 flex-1">
              <p class="text-sm font-medium text-gray-900 truncate">${user.name}</p>
              <p class="text-xs text-gray-500 truncate">${user.email}</p>
              <p class="text-xs text-gray-400 truncate">${user.user_email || ''}</p>
            </div>
          </div>
          <button data-action="click->segmentation-users#unassignUser" data-user-id="${user.id}" class="ml-3 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg p-2 transition-all opacity-0 group-hover:opacity-100">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      `).join('')
    }
  }

  search(event) {
    const availableList = document.querySelector('[data-segmentation-users-target="availableList"]')
    if (!availableList) return
    
    const query = event.target.value.toLowerCase()
    
    if (query.length === 0) {
      availableList.innerHTML = ''
      return
    }

    const filtered = this.availableUsers.filter(user =>
      user.name.toLowerCase().includes(query) ||
      user.email.toLowerCase().includes(query) ||
      (user.user_email && user.user_email.toLowerCase().includes(query))
    )

    if (filtered.length === 0) {
      availableList.innerHTML = `
        <div class="text-center py-8">
          <div class="inline-flex items-center justify-center w-12 h-12 bg-gray-100 rounded-full mb-2">
            <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </div>
          <p class="text-sm text-gray-500">No se encontraron usuarios</p>
        </div>
      `
    } else {
      availableList.innerHTML = `
        <div class="border-t border-gray-200 pt-4 mt-4">
          <h4 class="text-sm font-semibold text-gray-700 mb-3">Disponibles</h4>
          <div class="space-y-2">
            ${filtered.map(user => `
              <div data-action="click->segmentation-users#assignUser" data-user-id="${user.id}" class="flex items-center p-3 border border-gray-200 rounded-lg hover:bg-blue-50 hover:border-blue-300 hover:shadow-sm transition-all cursor-pointer group">
                <div class="w-9 h-9 bg-gradient-to-br from-gray-300 to-gray-400 rounded-full flex items-center justify-center text-white text-xs font-semibold mr-3 shadow-sm group-hover:from-blue-400 group-hover:to-blue-600 transition-all">
                  <span>${this.getInitials(user.name)}</span>
                </div>
                <div class="min-w-0 flex-1">
                  <p class="text-sm font-medium text-gray-900 truncate">${user.name}</p>
                  <p class="text-xs text-gray-500 truncate">${user.email}</p>
                  <p class="text-xs text-gray-400 truncate">${user.user_email || ''}</p>
                </div>
                <svg class="w-5 h-5 text-gray-400 group-hover:text-blue-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                </svg>
              </div>
            `).join('')}
          </div>
        </div>
      `
    }
  }

  async assignUser(event) {
    const userId = event.currentTarget.dataset.userId
    
    try {
      const response = await fetch(`/admin/segmentation/items/${this.itemIdValue}/assign_user`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name=csrf-token]').content
        },
        body: JSON.stringify({ employee_id: userId })
      })

      const data = await response.json()
      if (data.success) {
        // Recargar usuarios y la página
        await this.loadUsers()
        const searchInput = document.querySelector('[data-segmentation-users-target="searchInput"]')
        if (searchInput) searchInput.value = ''
        window.location.reload()
      }
    } catch (error) {
      console.error('Error assigning user:', error)
    }
  }

  async unassignUser(event) {
    const userId = event.currentTarget.dataset.userId
    
    try {
      const response = await fetch(`/admin/segmentation/items/${this.itemIdValue}/unassign_user/${userId}`, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': document.querySelector('[name=csrf-token]').content
        }
      })

      const data = await response.json()
      if (data.success) {
        // Recargar usuarios y la página
        await this.loadUsers()
        window.location.reload()
      }
    } catch (error) {
      console.error('Error unassigning user:', error)
    }
  }

  getInitials(name) {
    return name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()
  }

  showLoading() {
    const loadingState = document.querySelector('[data-segmentation-users-target="loadingState"]')
    const assignedList = document.querySelector('[data-segmentation-users-target="assignedList"]')
    if (loadingState) loadingState.style.display = 'flex'
    if (assignedList) assignedList.style.display = 'none'
  }

  hideLoading() {
    const loadingState = document.querySelector('[data-segmentation-users-target="loadingState"]')
    const assignedList = document.querySelector('[data-segmentation-users-target="assignedList"]')
    if (loadingState) loadingState.style.display = 'none'
    if (assignedList) assignedList.style.display = 'block'
  }
}
