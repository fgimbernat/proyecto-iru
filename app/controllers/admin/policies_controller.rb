# frozen_string_literal: true

module Admin
  class PoliciesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_policy, only: [:show, :edit, :update, :destroy, :toggle_status]
    before_action :set_policy_types, only: [:new, :edit, :create, :update]

    def index
      authorize Policy
      @policies = Policy.includes(:policy_type)
                        .ordered_by_name
                        .page(params[:page])
      
      # Filtro opcional por tipo de política
      if params[:policy_type_id].present?
        @policies = @policies.by_policy_type(params[:policy_type_id])
      end
    end

    def show
      authorize @policy
    end

    def new
      @policy = Policy.new
      authorize @policy
      
      # Valores por defecto
      set_default_values
    end

    def create
      @policy = Policy.new(policy_params)
      authorize @policy

      if @policy.save
        redirect_to admin_policy_path(@policy), notice: 'Política creada exitosamente.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @policy
    end

    def update
      authorize @policy

      if @policy.update(policy_params)
        redirect_to admin_policy_path(@policy), notice: 'Política actualizada exitosamente.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @policy

      if @policy.time_off_requests.exists?
        redirect_to admin_policies_path, 
                    alert: 'No se puede eliminar la política porque tiene solicitudes de tiempo libre asociadas.'
      elsif @policy.destroy
        redirect_to admin_policies_path, notice: 'Política eliminada exitosamente.'
      else
        redirect_to admin_policies_path, alert: 'Error al eliminar la política.'
      end
    end

    def toggle_status
      authorize @policy

      @policy.toggle_status!
      redirect_to admin_policies_path, 
                  notice: "Política #{@policy.active? ? 'activada' : 'desactivada'} exitosamente."
    end

    private

    def set_policy
      @policy = Policy.find(params[:id])
    end

    def set_policy_types
      @policy_types = PolicyType.active.ordered_by_name
    end

    def set_default_values
      @policy.entitlement_type = 'basic_annual'
      @policy.annual_entitlement = 0.0
      @policy.period_type = 'jan_dec'
      @policy.accrual_frequency = 'annual'
      @policy.accrual_timing = 'start_of_cycle'
      @policy.balance_precision = 'decimals'
      @policy.proration_calculation = 'working_days'
      @policy.min_advance_days = 1.0
      @policy.min_request_period = 1.0
      @policy.max_request_period = 1.0
      @policy.attachment_requirement = 'optional'
      @policy.new_hire_block_days = 1
      @policy.new_hire_block_unit = 'days'
      @policy.carryover_expiration_amount = 1
      @policy.carryover_expiration_unit = 'months'
    end

    def policy_params
      params.require(:policy).permit(
        # Básicos
        :policy_type_id,
        :name,
        :description,
        # Derecho a prestación
        :entitlement_type,
        :annual_entitlement,
        # Periodo de actividad
        :period_type,
        # Acumulación
        :accrual_frequency,
        :accrual_timing,
        # Visualización
        :balance_precision,
        # Prorrateo
        :proration_calculation,
        :grant_on_hire,
        :grant_on_termination,
        # Remanente (Carryover)
        :enable_carryover,
        :carryover_limit,
        :carryover_expires,
        :carryover_expiration_amount,
        :carryover_expiration_unit,
        # Saldo máximo
        :enable_max_balance,
        :max_balance,
        # Saldo mínimo
        :enable_min_balance,
        :min_balance,
        # Solicitudes de empleados
        :min_advance_days,
        :allow_retroactive,
        :allow_half_day,
        :min_request_period,
        :max_request_period,
        # Bloqueo nuevas contrataciones
        :block_new_hire_requests,
        :new_hire_block_days,
        :new_hire_block_unit,
        # Bloqueo general
        :block_employee_requests,
        # Archivo adjunto
        :attachment_requirement,
        # Instrucciones
        :instructions,
        # Estado
        :active
      )
    end
  end
end
