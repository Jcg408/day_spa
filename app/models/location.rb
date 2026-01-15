class Location < ApplicationRecord
    belongs_to :locatable, polymorphic: true
    
    enum :location_type, {primary: 0, billing: 1, shipping: 2, home: 3 }

    validates :street, :city, :postal_code, presence: true
end
