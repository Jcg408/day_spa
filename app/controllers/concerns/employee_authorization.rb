module EmployeeAuthorization
  extend ActiveSupport::Concern

  included do
    helper_method :logged_in?
  end

  def logged_in?
    current_employee.present?
  end

  def require_authentication
    unless logged_in?
      redirect_to root_path, alert: "You must be logged in to access this page."
    end
  end

  def require_manager
    unless current_employee&.manager_or_above?
      redirect_to root_path, alert: "You don't have permission to access this page."
    end
  end

  def require_admin
    unless current_employee&.admin?
      redirect_to root_path, alert: "You must be an administrator to access this page."
    end
  end

  # Check specific permissions
  def authorize_employee_management!
    unless current_employee&.can_manage_employees?
      redirect_to root_path, alert: "You don't have permission to manage employees."
    end
  end

  def authorize_business_settings!
    unless current_employee&.can_manage_business_settings?
      redirect_to root_path, alert: "You don't have permission to manage business settings."
    end
  end

  def authorize_financial_reports!
    unless current_employee&.can_view_financial_reports?
      redirect_to root_path, alert: "You don't have permission to view financial reports."
    end
  end
end
