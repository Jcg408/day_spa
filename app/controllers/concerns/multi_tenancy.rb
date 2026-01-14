module MultiTenancy
  extend ActiveSupport::Concern

  included do
    before_action :set_current_business
    helper_method :current_business
  end

  private

  def current_business
    @current_business ||= current_employee&.business
  end

  def set_current_business
    return unless logged_in?
    
    unless current_business
      session[:employee_id] = nil
      redirect_to login_path, alert: "Your account is not associated with a business."
    end
  end

  # Helper method to scope queries to current business
  def scope_to_business(relation)
    return relation unless current_business
    relation.where(business_id: current_business.id)
  end
end
