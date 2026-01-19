class Organization < ApplicationRecord
  belongs_to :owner, class_name: "Employee", optional: true
  has_many :businesses, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :clients, through: :businesses
  has_many :services, through: :businesses
  
  validates :name, presence: true
  validates :active, inclusion: { in: [true, false] }
end