class CreateLocations < ActiveRecord::Migration[8.1]
  def change
    create_table :locations, id: :uuid do |t|
      t.references :locatable, polymorphic: true, null: false
      t.string :street
      t.string :street2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.integer :location_type, default: 0
      t.timestamps
    end
  end
end
