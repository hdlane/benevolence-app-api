class CreateResources < ActiveRecord::Migration[7.2]
  def change
    create_table :resources do |t|
      t.references :request, null: false, foreign_key: true, index: true
      t.references :organization, null: false, foreign_key: true, index: true
      t.string :name, null: false
      t.string :kind, null: false
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
