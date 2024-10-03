class CreateOrganizations < ActiveRecord::Migration[7.2]
  def change
    create_table :organizations do |t|
      t.string :name, null: false, index: true
      t.string :access_token, index: { unique: true }
      t.string :refresh_token, index: { unique: true }
      t.integer :token_expires_at
      t.datetime :synced_at
      t.bigint :pco_id, null: false, limit: 1

      t.timestamps
    end
  end
end
