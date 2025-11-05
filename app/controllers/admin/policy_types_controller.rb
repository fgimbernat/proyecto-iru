# frozen_string_literal: true

module Admin
  class PolicyTypesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_policy_type, only: [:show, :edit, :update, :destroy, :toggle_status]

    def index
      authorize PolicyType
      @policy_types = PolicyType.ordered_by_name.page(params[:page])
    end

    def show
      authorize @policy_type
    end

    def new
      @policy_type = PolicyType.new
      authorize @policy_type
    end

    def create
      @policy_type = PolicyType.new(policy_type_params)
      authorize @policy_type

      if @policy_type.save
        redirect_to admin_policy_type_path(@policy_type), notice: 'Tipo de política creado exitosamente.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @policy_type
    end

    def update
      authorize @policy_type

      if @policy_type.update(policy_type_params)
        redirect_to admin_policy_type_path(@policy_type), notice: 'Tipo de política actualizado exitosamente.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @policy_type

      if @policy_type.policies.exists?
        redirect_to admin_policy_types_path, 
                    alert: 'No se puede eliminar el tipo de política porque tiene políticas asociadas.'
      elsif @policy_type.destroy
        redirect_to admin_policy_types_path, notice: 'Tipo de política eliminado exitosamente.'
      else
        redirect_to admin_policy_types_path, alert: 'Error al eliminar el tipo de política.'
      end
    end

    def toggle_status
      authorize @policy_type

      @policy_type.toggle_status!
      redirect_to admin_policy_types_path, 
                  notice: "Tipo de política #{@policy_type.active? ? 'activado' : 'desactivado'} exitosamente."
    end

    private

    def set_policy_type
      @policy_type = PolicyType.find(params[:id])
    end

    def policy_type_params
      params.require(:policy_type).permit(:name, :unit, :active)
    end
  end
end
