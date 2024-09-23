class CreateRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :requests do |t|
      t.string :type, null: false
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
      t.integer :organization_id, null: false
      t.integer :person_id, null: false

      t.timestamps
    end
  end
end
