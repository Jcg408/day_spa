module EmployeeAuthorization
  extend ActiveSupport::Concern

  included do
    helper_method :logged_in?, :organization_owner?, :can_manage_business?, :can_manage_resources?
  end

  def logged_in?
    current_employee.present?
  end

  def require_authentication
    unless logged_in?
      redirect_to login_path, alert: "You must be logged in to access this page."
    end
  end

  # Organization-level authorization
  def require_organization_owner
    unless current_employee&.organization_owner?
      redirect_to root_path, alert: "You must be the organization owner to access this page."
    end
  end

  def organization_owner?
    current_employee&.organization_owner?
  end

  # Business-level authorization
  def require_business_admin
    unless can_manage_business?
      redirect_to root_path, alert: "You must be a business administrator to access this page."
    end
  end

  def require_resource_management
    unless can_manage_resources?
      redirect_to root_path, alert: "You don't have permission to manage this resource."
    end
  end

  def can_manage_business?
    return false unless current_employee && current_business
    current_employee.can_manage_business?(current_business)
  end

  def can_manage_resources?
    return false unless current_employee && current_business
    current_employee.can_manage_resources_at?(current_business)
  end

  def can_destroy_records?
    return false unless current_employee && current_business
    current_employee.can_destroy_at?(current_business)
  end

  # Self-edit authorization
  def authorize_self_or_admin(employee)
    unless current_employee == employee || can_manage_resources?
      redirect_to root_path, alert: "You can only edit your own profile."
    end
  end
end
