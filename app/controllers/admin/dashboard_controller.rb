module Admin
  class DashboardController < BaseController
    def index
      @users_count = User.count
      @employees_count = Employee.count
      @departments_count = Department.count
      @positions_count = Position.count
    end
  end
end
