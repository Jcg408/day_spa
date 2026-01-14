class Employee < ApplicationRecord
  belongs_to :business

  # Authentication
  has_secure_password
  
  # Role-based access control
  enum :role, { staff: 0, manager: 1, admin: 2 }, default: :staff

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Authorization helper methods
  def admin?
    role == "admin"
  end

  def manager_or_above?
    manager? || admin?
  end

  def can_manage_employees?
    manager_or_above?
  end

  def can_manage_business_settings?
    admin?
  end

  def can_view_financial_reports?
    manager_or_above?
  end
end
