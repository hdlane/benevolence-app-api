class CreateRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :requests do |t|
      t.references :person, null: false, foreign_key: true, index: true
      t.references :organization, null: false, foreign_key: { on_delete: :cascade }, index: true
      t.string :request_type, null: false
      t.string :title, null: false
      t.text :notes
      t.text :allergies
      t.date :start_date
      t.time :start_time
      t.date :end_date
      t.time :end_time
      t.string :street_line
      t.string :city
      t.string :state
      t.string :zip_code

      t.timestamps
    end
    add_index :requests, [ :person_id, :organization_id ]
  end
end
