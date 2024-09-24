class CreateCoordinators < ActiveRecord::Migration[7.2]
  def change
    create_table :coordinators do |t|
      t.references :person_id, null: false, foreign_key: true, index: true
      t.references :request_id, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
