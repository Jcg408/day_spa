class AddRoleToEmployees < ActiveRecord::Migration[8.1]
  def change
    add_column :employees, :role, :integer, default: 0, null: false
    add_index :employees, :role
  end
end
