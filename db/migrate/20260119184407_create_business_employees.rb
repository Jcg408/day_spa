class CreateBusinessEmployees < ActiveRecord::Migration[8.1]
 def change
    create_table :business_employees, id: :uuid do |t|
      t.references :business, type: :uuid, null: false, foreign_key: true
      t.references :employee, type: :uuid, null: false, foreign_key: true
      t.integer :role, default: 0, null: false
      t.boolean :primary_location, default: false, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :business_employees, [:business_id, :employee_id], unique: true
    add_index :business_employees, [:employee_id, :primary_location], 
              where: "primary_location = true", 
              name: "index_business_employees_on_employee_primary"
  end
end
