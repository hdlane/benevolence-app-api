class CreateResources < ActiveRecord::Migration[7.2]
  def change
    create_table :resources do |t|
      t.references :request, null: false, foreign_key: { on_delete: :cascade }, index: true
      t.references :organization, null: false, foreign_key: { on_delete: :cascade }, index: true
      t.string :name
      t.string :kind, null: false
      t.integer :quantity, null: false
      t.integer :assigned, null: false

      t.timestamps
    end
  end
end
