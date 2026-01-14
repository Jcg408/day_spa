class Business < ApplicationRecord
  has_many :services
  has_many :employees
  has_many :suppliers
end
