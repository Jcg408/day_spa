class EmployeesController < ApplicationController
  before_action :require_resource_management, only: [:new, :create]
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_action :authorize_employee_action, only: [:edit, :update]
  before_action :require_destroy_permission, only: [:destroy]

  def index
    @employees = current_business.employees.order(:name)
  end

  def show
  end

  def new
    @employee = Employee.new
    @employee.phones.build
    @employee.locations.build
  end

  def create
    @employee = current_employee.organization.employees.build(employee_params)
    
    if @employee.save
      # Assign to current business with staff role by default
      @employee.business_employees.create!(business: current_business, role: :staff, primary_location: true)
      redirect_to employee_path(@employee), notice: "Employee created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      redirect_to employee_path(@employee), notice: "Employee updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @employee.destroy
    redirect_to employees_path, notice: "Employee removed successfully."
  end

  private

  def set_employee
    @employee = current_business.employees.find(params[:id])
  end

  def authorize_employee_action
    authorize_self_or_admin(@employee)
  end

  def require_destroy_permission
    unless can_destroy_records?
      redirect_to employees_path, alert: "You don't have permission to delete employees."
    end
  end

  def employee_params
    base_attributes = [
      :name, :email, :bio, :password, :password_confirmation,
      phones_attributes: [:id, :number, :phone_type, :extension, :_destroy],
      locations_attributes: [:id, :street, :street2, :city, :state, :postal_code, :country, :location_type, :_destroy]
    ]
    
    base_attributes << :role if current_employee.admin?
    
    params.require(:employee).permit(base_attributes)
  end
end
