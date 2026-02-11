module MultiTenancy
  extend ActiveSupport::Concern

  included do
    before_action :set_current_business
    helper_method :current_business
  end

  private

  def current_business
    return @current_business if defined?(@current_business)

    @current_business = nil
    if current_employee && session[:current_business_id].present?
      @current_business = current_employee.organization.businesses.find_by(id: session[:current_business_id])
    end

    @current_business ||= current_employee&.primary_business
  end

  def set_current_business
    return unless logged_in?
    
    unless current_business
      session[:employee_id] = nil
      session.delete(:current_business_id)
      redirect_to login_path, alert: "Your account is not associated with a business."
    end
  end

  def set_current_business_session(business)
    return unless business

    session[:current_business_id] = business.id
    @current_business = business
  end

  # Helper method to scope queries to current business
  def scope_to_business(relation)
    return relation unless current_business
    relation.where(business_id: current_business.id)
  end
end
