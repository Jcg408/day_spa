class Phone < ApplicationRecord
    belongs_to :phoneable, polymorphic: true

    enum :phone_type, {mobile: 0, work: 1, home: 2, fax: 3, main: 4, other: 5 }
    
    validates :number, presence: true
    validates :phone_type, presence: true
end 
  
