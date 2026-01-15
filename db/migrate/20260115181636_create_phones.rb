class CreatePhones < ActiveRecord::Migration[8.1]
  def change
    create_table :phones, id: :uuid do |t|
      t.references :phoneable, polymorphic: true, null: false
      t.string :number, null: false
      t.integer :phone_type, default: 0
      t.string :extension
      t.timestamps
    end
  end
end
