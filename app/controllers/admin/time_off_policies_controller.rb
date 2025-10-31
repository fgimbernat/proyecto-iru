class Admin::TimeOffPoliciesController < Admin::BaseController
  before_action :set_policy, only: [:show, :edit, :update, :destroy, :toggle_active]

  def index
    @policies = TimeOffPolicy.order(created_at: :desc)
    @policies = @policies.where(policy_type: params[:type]) if params[:type].present?
    @policies = @policies.where(active: params[:active]) if params[:active].present?
  end

  def show
    @recent_requests = @policy.time_off_requests.order(created_at: :desc).limit(10)
  end

  def new
    @policy = TimeOffPolicy.new
  end

  def create
    @policy = TimeOffPolicy.new(policy_params)

    if @policy.save
      redirect_to admin_time_off_policies_path, notice: 'Política creada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @policy.update(policy_params)
      redirect_to admin_time_off_policy_path(@policy), notice: 'Política actualizada exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @policy.destroy
      redirect_to admin_time_off_policies_path, notice: 'Política eliminada exitosamente.'
    else
      redirect_to admin_time_off_policies_path, alert: 'No se puede eliminar la política porque tiene solicitudes asociadas.'
    end
  end

  def toggle_active
    @policy.update(active: !@policy.active)
    redirect_to admin_time_off_policies_path, notice: "Política #{@policy.active? ? 'activada' : 'desactivada'} exitosamente."
  end

  private

  def set_policy
    @policy = TimeOffPolicy.find(params[:id])
  end

  def policy_params
    params.require(:time_off_policy).permit(
      :name, :description, :policy_type, :days_per_year,
      :requires_approval, :active, :icon, :color
    )
  end
end
