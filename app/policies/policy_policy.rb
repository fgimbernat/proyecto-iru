# frozen_string_literal: true

class PolicyPolicy < ApplicationPolicy
  def index?
    user.admin? || user.manager?
  end

  def show?
    user.admin? || user.manager?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    # TODO: Descomentar cuando se migre time_off_requests a usar policy_id
    # user.admin? && !record.time_off_requests.exists?
    user.admin?
  end

  def toggle_status?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user.admin? || user.manager?
        scope.all
      else
        scope.none
      end
    end
  end
end
