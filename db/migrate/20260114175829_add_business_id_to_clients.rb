class AddBusinessIdToClients < ActiveRecord::Migration[8.1]
  def change
    add_reference :clients, :business, foreign_key: true, type: :uuid
  end
end
