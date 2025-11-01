class HolidayPolicy < ApplicationPolicy
  def index?
    user.present? # Todos los usuarios pueden ver festivos
  end

  def show?
    user.present?
  end

  def create?
    user.admin?
  end

  def new?
    create?
  end

  def update?
    user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end

  def activate?
    user.admin?
  end

  def deactivate?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user.present?
        scope.all
      else
        scope.none
      end
    end
  end
end
