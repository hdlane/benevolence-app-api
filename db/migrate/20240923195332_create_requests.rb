class CreateRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :requests do |t|
      t.references :recipient, null: false, index: true
      t.references :coordinator, null: false, index: true
      t.references :creator, null: false, index: true
      t.references :organization, null: false, foreign_key: { on_delete: :cascade }, index: true
      t.string :request_type, null: false
      t.string :title, null: false
      t.text :notes
      t.text :allergies
      t.date :start_date, null: false
      t.time :start_time
      t.date :end_date
      t.time :end_time
      t.string :street_line
      t.string :city
      t.string :state
      t.string :zip_code

      t.timestamps
    end
    add_index :requests, [ :organization_id, :recipient_id, :coordinator_id, :creator_id ]
  end
end
