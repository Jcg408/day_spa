class Client < ApplicationRecord
  has_many :phones, as: :phoneable, dependent: :destroy
  has_many :locations, as: :locatable, dependent: :destroy
  accepts_nested_attributes_for: :phones, :locations
  
  validates_presence_of :name
end
