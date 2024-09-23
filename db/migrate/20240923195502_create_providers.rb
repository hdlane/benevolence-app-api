class CreateProviders < ActiveRecord::Migration[7.2]
  def change
    create_table :providers do |t|
      t.integer :quantity, null: false
      t.integer :person_id, null: false
      t.integer :resource_id, null: false

      t.timestamps
    end
  end
end
