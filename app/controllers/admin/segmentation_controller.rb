module Admin
  class SegmentationController < BaseController
    before_action :set_segmentation, only: [:update_segmentation, :destroy_segmentation]
    before_action :set_item, only: [:update_item, :destroy_item, :item_users, :assign_user, :unassign_user]
    
    def index
      @segmentations = Segmentation.includes(:segmentation_items).order(:name)
    end

    # Crear nueva segmentación
    def create_segmentation
      @segmentation = Segmentation.new(segmentation_params)
      if @segmentation.save
        redirect_to admin_segmentation_path, notice: 'Segmentación creada exitosamente'
      else
        redirect_to admin_segmentation_path, alert: @segmentation.errors.full_messages.join(', ')
      end
    end

    # Actualizar segmentación
    def update_segmentation
      if @segmentation.update(segmentation_params)
        redirect_to admin_segmentation_path, notice: 'Segmentación actualizada exitosamente'
      else
        redirect_to admin_segmentation_path, alert: @segmentation.errors.full_messages.join(', ')
      end
    end

    # Eliminar segmentación
    def destroy_segmentation
      if @segmentation.is_system?
        redirect_to admin_segmentation_path, alert: 'No se pueden eliminar segmentaciones del sistema (Área, Jerarquía, Ubicación)'
      elsif @segmentation.destroy
        redirect_to admin_segmentation_path, notice: 'Segmentación eliminada exitosamente'
      else
        redirect_to admin_segmentation_path, alert: 'No se pudo eliminar la segmentación'
      end
    end

    # Crear item de segmentación
    def create_item
      @segmentation = Segmentation.find(params[:segmentation_id])
      @item = @segmentation.segmentation_items.new(item_params)
      if @item.save
        redirect_to admin_segmentation_path, notice: 'Item creado exitosamente'
      else
        redirect_to admin_segmentation_path, alert: @item.errors.full_messages.join(', ')
      end
    end

    # Actualizar item de segmentación
    def update_item
      if @item.update(item_params)
        redirect_to admin_segmentation_path, notice: 'Item actualizado exitosamente'
      else
        redirect_to admin_segmentation_path, alert: @item.errors.full_messages.join(', ')
      end
    end

    # Eliminar item de segmentación
    def destroy_item
      if @item.destroy
        redirect_to admin_segmentation_path, notice: 'Item eliminado exitosamente'
      else
        redirect_to admin_segmentation_path, alert: 'No se pudo eliminar el item'
      end
    end

    # Obtener usuarios asignados a un item
    def item_users
      render json: {
        assigned_users: serialize_employees(@item.employees.includes(:user)),
        available_users: serialize_employees(available_employees)
      }
    end

    # Asignar usuario a un item
    def assign_user
      @employee = Employee.find(params[:employee_id])
      @employee_segmentation = EmployeeSegmentation.new(
        employee_id: @employee.id,
        segmentation_item_id: @item.id
      )

      if @employee_segmentation.save
        render json: { 
          success: true, 
          message: 'Usuario asignado exitosamente',
          user: serialize_employee(@employee)
        }
      else
        render json: { 
          success: false, 
          message: @employee_segmentation.errors.full_messages.join(', ')
        }, status: :unprocessable_entity
      end
    end

    # Desasignar usuario de un item
    def unassign_user
      @employee = Employee.find(params[:employee_id])
      @employee_segmentation = EmployeeSegmentation.find_by(
        employee_id: @employee.id,
        segmentation_item_id: @item.id
      )

      if @employee_segmentation&.destroy
        render json: { success: true, message: 'Usuario desasignado exitosamente' }
      else
        render json: { success: false, message: 'No se pudo desasignar el usuario' }, 
               status: :unprocessable_entity
      end
    end

    private
    
    # Before action callbacks
    def set_segmentation
      @segmentation = Segmentation.find(params[:id])
    end
    
    def set_item
      @item = SegmentationItem.find(params[:id])
    end
    
    # Serializers (patrón para evitar lógica en vistas/controladores)
    def serialize_employees(employees)
      employees.map { |employee| serialize_employee(employee) }
    end
    
    def serialize_employee(employee)
      {
        id: employee.id,
        name: employee.full_name,
        email: employee.email,
        user_email: employee.user&.email
      }
    end
    
    def available_employees
      Employee.joins(:user)
              .where.not(id: @item.employees.pluck(:id))
              .order(:first_name, :last_name)
              .limit(50)
    end
    
    # Strong parameters
    def segmentation_params
      params.require(:segmentation).permit(:name, :visibility)
    rescue ActionController::ParameterMissing
      params.permit(:name, :visibility)
    end

    def item_params
      params.require(:segmentation_item).permit(:name)
    rescue ActionController::ParameterMissing
      params.permit(:name)
    end
  end
end
