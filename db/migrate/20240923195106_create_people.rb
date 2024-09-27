class CreatePeople < ActiveRecord::Migration[7.2]
  def change
    create_table :people do |t|
      t.references :organization, null: false, foreign_key: { on_delete: :cascade }, index: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :name, null: false
      t.string :email, index: true
      t.string :phone_number, index: true
      t.boolean :is_admin, null: false
      t.integer :pco_person_id, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
