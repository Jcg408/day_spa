class AddPasswordDigestAndEmailToEmployees < ActiveRecord::Migration[8.1]
  def change
    add_column :employees, :password_digest, :string
    add_column :employees, :email, :string
    add_index :employees, :email, unique: true
  end
end
