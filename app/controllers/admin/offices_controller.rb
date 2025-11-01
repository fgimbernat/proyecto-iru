class Admin::OfficesController < Admin::BaseController
  before_action :set_office, only: [:show, :edit, :update, :destroy, :toggle_active]
  before_action :load_regions, only: [:new, :edit, :create, :update]

  def index
    authorize Office
    @regions = Region.active.ordered
    @offices = policy_scope(Office).includes(:region).ordered
    @offices = @offices.where(active: params[:active]) if params[:active].present?
    @offices = @offices.where(region_id: params[:region_id]) if params[:region_id].present?
    @offices = @offices.page(params[:page])
  end

  def show
    authorize @office
    @employees = @office.employees.page(params[:page])
  end

  def new
    @office = Office.new
    @office.region_id = params[:region_id] if params[:region_id].present?
    authorize @office
  end

  def create
    @office = Office.new(office_params)
    authorize @office

    if @office.save
      redirect_to admin_office_path(@office), notice: 'Sede creada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @office
  end

  def update
    authorize @office
    
    if @office.update(office_params)
      redirect_to admin_office_path(@office), notice: 'Sede actualizada exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @office
    
    if @office.destroy
      redirect_to admin_offices_path, notice: 'Sede eliminada exitosamente.'
    else
      redirect_to admin_offices_path, alert: 'No se puede eliminar la sede porque tiene empleados asignados.'
    end
  end

  def toggle_active
    authorize @office, :update?
    
    if @office.active?
      @office.deactivate!
      message = 'Sede desactivada exitosamente.'
    else
      @office.activate!
      message = 'Sede activada exitosamente.'
    end
    
    redirect_to admin_offices_path, notice: message
  end

  private

  def set_office
    @office = Office.find(params[:id])
  end

  def load_regions
    @regions = Region.active.ordered
  end

  def office_params
    params.require(:office).permit(:name, :description, :address, :region_id, :active)
  end
end
