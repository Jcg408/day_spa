class Business < ApplicationRecord
  has_many :services
  has_many :employees
  has_many :suppliers
  has_many :phones, as: :phoneable, dependent: :destroy
  has_many :locations, as: :locatable, dependent: :destroy
  accepts_nested_attributes_for :phones, :locations, allow_destroy: true
end
