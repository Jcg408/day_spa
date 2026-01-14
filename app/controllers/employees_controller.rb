class EmployeesController < ApplicationController
  before_action :require_manager, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  def index
    @employees = current_business.employees.order(:name)
  end

  def show
  end

  def new
    @employee = current_business.employees.build
  end

  def create
    @employee = current_business.employees.build(employee_params)
    
    if @employee.save
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

  def employee_params
    # Regular employees can only update their own basic info
    if current_employee.admin?
      params.require(:employee).permit(:name, :email, :bio, :role, :password, :password_confirmation)
    elsif current_employee.manager?
      params.require(:employee).permit(:name, :email, :bio, :password, :password_confirmation)
    else
      params.require(:employee).permit(:name, :bio, :password, :password_confirmation)
    end
  end
end
