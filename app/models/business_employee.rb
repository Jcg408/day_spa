class BusinessEmployee < ApplicationRecord
  belongs_to :business
  belongs_to :employee
  
  enum :role, { staff: 0, manager: 1, admin: 2 }, default: :staff
  
  validates :role, presence: true
  validates :business_id, uniqueness: { scope: :employee_id }
  validate :only_one_primary_location_per_employee
  
  # Role hierarchy methods
  def manager_or_above?
    role.in?(%w[manager admin])
  end
  
  def staff_or_above?
    true  # Everyone has at least staff access
  end
  
  # Business management permissions
  def can_destroy_records?
    admin?  # Only business admin (org owner checked separately in Employee model)
  end
  
  def can_manage_business_settings?
    admin?
  end
  
  def can_manage_employees?
    admin?
  end
  
  def can_manage_services?
    admin?
  end
  
  def can_manage_suppliers?
    admin?
  end
  
  def can_manage_products?
    admin?
  end
  
  # Appointment permissions
  def can_book_appointments?
    true  # All roles can book
  end
  
  # Client permissions
  def can_view_client_info?
    true  # All roles can view
  end
  
  def can_edit_client_info?
    admin?  # Only admin can edit client records
  end
  
  def can_destroy_clients?
    admin?  # Only admin can destroy client records
  end
  
  private
  
  def only_one_primary_location_per_employee
    if primary_location? && employee.business_employees.where(primary_location: true).where.not(id: id).exists?
      errors.add(:primary_location, "employee can only have one primary location")
    end
  end
end