class SessionsController < ApplicationController
  def new
    # Login form
  end

  def create
    employee = Employee.find_by(email: params[:email]&.downcase)
    
    if employee&.authenticate(params[:password])
      session[:employee_id] = employee.id
      redirect_to root_path, notice: "Welcome back, #{employee.name}!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:employee_id] = nil
    redirect_to login_path, notice: "You have been logged out."
  end
end
