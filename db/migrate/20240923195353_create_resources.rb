class CreateResources < ActiveRecord::Migration[7.2]
  def change
    create_table :resources do |t|
      t.string :name, null: false
      t.string :kind, null: false
      t.integer :quantity, null: false
      t.integer :request_id, null: false

      t.timestamps
    end
  end
end
