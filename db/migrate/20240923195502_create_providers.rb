class CreateProviders < ActiveRecord::Migration[7.2]
  def change
    create_table :providers do |t|
      t.references :person, null: false, foreign_key: { on_delete: :cascade }, index: true
      t.references :resource, null: false, foreign_key: { on_delete: :cascade }, index: true
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
