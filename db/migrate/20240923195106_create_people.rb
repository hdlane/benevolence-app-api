class CreatePeople < ActiveRecord::Migration[7.2]
  def change
    create_table :people do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :name
      t.string :email
      t.string :phone_number
      t.integer :pco_person_id, null: false, index { unique: true }

      t.timestamps
    end
  end
end
