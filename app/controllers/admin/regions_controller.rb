class Admin::RegionsController < Admin::BaseController
  before_action :set_region, only: [:show, :edit, :update, :destroy, :toggle_active]

  def index
    authorize Region
    @regions = policy_scope(Region).ordered
    @regions = @regions.where(active: params[:active]) if params[:active].present?
    @regions = @regions.page(params[:page])
  end

  def show
    authorize @region
    @offices = @region.offices.ordered.page(params[:page])
    @holidays = @region.holidays.current_year.ordered
  end

  def new
    @region = Region.new
    authorize @region
  end

  def create
    @region = Region.new(region_params)
    authorize @region

    if @region.save
      redirect_to admin_region_path(@region), notice: 'Región creada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @region
  end

  def update
    authorize @region
    
    if @region.update(region_params)
      redirect_to admin_region_path(@region), notice: 'Región actualizada exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @region
    
    if @region.destroy
      redirect_to admin_regions_path, notice: 'Región eliminada exitosamente.'
    else
      redirect_to admin_regions_path, alert: 'No se puede eliminar la región porque tiene sedes asociadas.'
    end
  end

  def toggle_active
    authorize @region, :update?
    
    if @region.active?
      @region.deactivate!
      message = 'Región desactivada exitosamente.'
    else
      @region.activate!
      message = 'Región activada exitosamente.'
    end
    
    redirect_to admin_regions_path, notice: message
  end

  private

  def set_region
    @region = Region.find(params[:id])
  end

  def region_params
    params.require(:region).permit(:name, :description, :active)
  end
end
