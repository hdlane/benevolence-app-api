class CreateCoordinators < ActiveRecord::Migration[7.2]
  def change
    create_table :coordinators do |t|
      t.references :person, null: false, foreign_key: { on_delete: :cascade }, index: true
      t.references :request, null: false, foreign_key: { on_delete: :cascade }, index: true

      t.timestamps
    end
  end
end
