class CreateOrganizations < ActiveRecord::Migration[7.2]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :email, null: false, index: {unique: true}
      t.datetime :synced_at
      t.integer :pco_id, null: false, index: {unique: true}

      t.timestamps
    end
  end
end
