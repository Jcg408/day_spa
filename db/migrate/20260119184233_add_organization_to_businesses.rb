class AddOrganizationToBusinesses < ActiveRecord::Migration[8.1]
  def change
    add_reference :businesses, :organization, type: :uuid, foreign_key: true
  end
end
