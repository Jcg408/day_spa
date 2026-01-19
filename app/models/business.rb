class Business < ApplicationRecord
  belongs_to :organization
  has_many :business_employees, dependent: :destroy
  has_many :employees, through: :business_employees
  has_many :services
  has_many :phones, as: :phoneable, dependent: :destroy
  has_many :locations, as: :locatable, dependent: :destroy
  has_many :suppliers
  
  accepts_nested_attributes_for :phones, :locations, allow_destroy: true

  validates :name, presence: true
  validates :active, inclusion: { in: [true, false] }
end