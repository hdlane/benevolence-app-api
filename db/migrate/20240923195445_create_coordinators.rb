class CreateCoordinators < ActiveRecord::Migration[7.2]
  def change
    create_table :coordinators do |t|
      t.integer :person_id, null: false
      t.integer :request_id, null: false

      t.timestamps
    end
  end
end
