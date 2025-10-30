module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!
    
    layout 'admin'

    private

    def require_admin!
      unless current_user.admin? || current_user.manager?
        redirect_to root_path, alert: 'No tienes permisos para acceder a esta sección.'
      end
    end
  end
end
