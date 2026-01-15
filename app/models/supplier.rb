class Supplier < ApplicationRecord
  has_many :phones, as: :phoneable, dependent: :destroy
  has_many :locations, as: :locatable, dependent: :destroy
  accepts_nested_attributes_for: :phones, :locations
  
  has_many :products
end
