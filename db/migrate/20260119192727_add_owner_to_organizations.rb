class AddOwnerToOrganizations < ActiveRecord::Migration[8.1]
  def change
    add_reference :organizations, :owner, null: false, foreign_key: { to_table: :employees }, type: :uuid
  end
end
