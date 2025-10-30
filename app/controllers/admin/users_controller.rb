module Admin
  class UsersController < BaseController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :load_form_data, only: [:new, :edit, :create, :update]

    def index
      @users = User.includes(:employee)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(20)
      
      # Filtro por búsqueda
      if params[:search].present?
        @users = @users.where("email ILIKE ?", "%#{params[:search]}%")
      end
      
      # Filtro por estado
      if params[:status].present? && params[:status] != 'all'
        @users = @users.where(role: params[:status])
      end
    end

    def show
    end

    def new
      @user = User.new
      @user.build_employee
    end

    def create
      @user = User.new(user_params)
      
      if @user.save
        redirect_to admin_user_path(@user), notice: 'Usuario creado exitosamente.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @user.build_employee unless @user.employee
    end

    def update
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: 'Usuario actualizado exitosamente.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: 'Usuario eliminado exitosamente.'
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def load_form_data
      @departments = Department.where(active: true).order(:name)
      @positions = Position.order(:title)
      @potential_managers = Employee.where.not(id: @user&.employee&.id).order(:first_name)
      @areas = Area.where(active: true).order(:name)
      @hierarchies = Hierarchy.where(active: true).order(:name)
      @locations = Location.where(active: true).order(:name)
    end

    def user_params
      params.require(:user).permit(
        :email, 
        :password, 
        :password_confirmation, 
        :role,
        :pin_code,
        employee_attributes: [
          :id,
          :first_name,
          :last_name,
          :middle_name,
          :document_type,
          :document_number,
          :birth_date,
          :gender,
          :marital_status,
          :email,
          :phone,
          :mobile,
          :address,
          :city,
          :state,
          :postal_code,
          :country,
          :hire_date,
          :termination_date,
          :employment_status,
          :employment_type,
          :position_id,
          :department_id,
          :manager_id,
          :salary,
          :currency,
          :linkedin,
          :instagram,
          :facebook,
          :twitter,
          :education,
          :position_title,
          :civil_status,
          :languages,
          :lives_in,
          :salary_2023,
          :salary_2024,
          :emergency_contact,
          :books,
          :team,
          :_destroy,
          area_ids: [],
          hierarchy_ids: [],
          location_ids: []
        ]
      )
    end
  end
end
