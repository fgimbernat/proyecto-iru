class Admin::HolidaysController < Admin::BaseController
  before_action :set_holiday, only: [:show, :edit, :update, :destroy, :toggle_active]
  before_action :load_regions, only: [:new, :edit, :create, :update, :index]

  def index
    authorize Holiday
    @regions = Region.active.ordered
    @holidays = policy_scope(Holiday).includes(:region).ordered
    @holidays = @holidays.where(active: params[:active]) if params[:active].present?
    @holidays = @holidays.where(region_id: params[:region_id]) if params[:region_id].present?
    
    if params[:year].present?
      @holidays = @holidays.in_year(params[:year].to_i)
    else
      @holidays = @holidays.current_year
    end
    
    @holidays = @holidays.page(params[:page])
    @years = Holiday.pluck(Arel.sql('EXTRACT(YEAR FROM date)')).uniq.sort.reverse
  end

  def show
    authorize @holiday
  end

  def new
    @holiday = Holiday.new
    @holiday.region_id = params[:region_id] if params[:region_id].present?
    @holiday.date = Date.current if @holiday.date.nil?
    authorize @holiday
  end

  def create
    @holiday = Holiday.new(holiday_params)
    authorize @holiday

    if @holiday.save
      redirect_to admin_holidays_path, notice: 'Festivo creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @holiday
  end

  def update
    authorize @holiday
    
    if @holiday.update(holiday_params)
      redirect_to admin_holidays_path, notice: 'Festivo actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @holiday
    
    if @holiday.destroy
      redirect_to admin_holidays_path, notice: 'Festivo eliminado exitosamente.'
    else
      redirect_to admin_holidays_path, alert: 'No se pudo eliminar el festivo.'
    end
  end

  def toggle_active
    authorize @holiday, :update?
    
    if @holiday.active?
      @holiday.deactivate!
      message = 'Festivo desactivado exitosamente.'
    else
      @holiday.activate!
      message = 'Festivo activado exitosamente.'
    end
    
    redirect_to admin_holidays_path, notice: message
  end

  private

  def set_holiday
    @holiday = Holiday.find(params[:id])
  end

  def load_regions
    @regions = Region.active.ordered
  end

  def holiday_params
    params.require(:holiday).permit(:name, :date, :region_id, :active)
  end
end
