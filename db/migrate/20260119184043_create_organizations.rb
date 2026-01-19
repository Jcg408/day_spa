class CreateOrganizations < ActiveRecord::Migration[8.1]
  def change
    create_table :organizations, id: :uuid do |t|
      t.string :name, null: false
      t.boolean :active, default: true, null: false
      t.text :description
      
      t.timestamps
    end

    add_index :organizations, :name
  end
end