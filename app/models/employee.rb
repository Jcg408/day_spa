class Employee < ApplicationRecord
  belongs_to :organization
  has_many :business_employees, dependent: :destroy
  has_many :businesses, through: :business_employees
  has_many :phones, as: :phoneable, dependent: :destroy
  has_many :locations, as: :locatable, dependent: :destroy
  
  accepts_nested_attributes_for :phones, :locations

  has_secure_password
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Helper methods
  def primary_business
    business_employees.find_by(primary_location: true)&.business
  end
  
  def emp_role(business)
    business_employees.find_by(business: business)
  end
  
  # Organization-level permissions
  def organization_owner?
    organization.owner_id == id
  end
  
  # Business-level permission checks
  def business_admin_at?(business)
    emp_role(business)&.admin?
  end
  
  # Combined permission checks (org owner OR business admin)
  def can_destroy_at?(business)
    organization_owner? || business_admin_at?(business)
  end
  
  def can_manage_business?(business)
    organization_owner? || business_admin_at?(business)
  end
  
  def can_manage_resources_at?(business)
    organization_owner? || business_admin_at?(business)
  end
  
  # Staff-level permissions
  def can_edit_own_profile?
    true
  end
  
  def can_book_appointments_at?(business)
    emp_role(business).present?  # Any role at the business
  end
  
  def can_view_schedules_at?(business)
    emp_role(business).present?  # Any role at the business
  end
end