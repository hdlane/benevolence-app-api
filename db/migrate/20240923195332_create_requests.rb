class CreateRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :requests do |t|
      t.references :recipient, null: false, index: true
      t.references :coordinator, null: false, index: true
      t.references :creator, null: false, index: true
      t.references :organization, null: false, foreign_key: { on_delete: :cascade }, index: true
      t.string :status, null: false
      t.string :request_type, null: false
      t.string :title, null: false
      t.text :notes, null: false
      t.text :allergies
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.string :street_line, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false

      t.timestamps
    end
    add_index :requests, [ :organization_id, :recipient_id, :coordinator_id, :creator_id ]
  end
end
