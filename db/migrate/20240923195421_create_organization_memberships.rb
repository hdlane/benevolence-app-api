class CreateOrganizationMemberships < ActiveRecord::Migration[7.2]
  def change
    create_table :organization_memberships do |t|
      t.boolean :is_current
      t.boolean :is_admin
      t.integer :organization_id, null: false
      t.integer :person_id, null: false

      t.timestamps
    end
  end
end
