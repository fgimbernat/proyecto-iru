module Admin
  class UsersController < BaseController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :load_form_data, only: [:new, :edit, :create, :update]

  def index
    @users = User.includes(employee: [:department, :position]).all
    
    # Filtro de búsqueda
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @users = @users.left_joins(:employee).where(
        "users.email LIKE ? OR employees.first_name LIKE ? OR employees.last_name LIKE ? OR employees.middle_name LIKE ?", 
        search_term, search_term, search_term, search_term
      )
    end
    
    # Filtro de estado
    if params[:status].present? && params[:status] != 'all'
      case params[:status]
      when 'active'
        # Usuarios activos (por ahora todos son activos)
        @users = @users.where.not(id: nil)
      when 'no_login'
        # Usuarios que nunca han iniciado sesión (por ahora vacío)
        @users = @users.where(id: nil)
      when 'inactive'
        # Usuarios desactivados (por ahora vacío)
        @users = @users.where(id: nil)
      end
    end
    
    @users = @users.order(created_at: :desc)
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
      @segmentations = Segmentation.includes(:segmentation_items).all.order(:name)
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
          segmentation_item_ids: []
        ]
      )
    end
  end
end
