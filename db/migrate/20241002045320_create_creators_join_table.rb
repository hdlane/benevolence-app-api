class CreateCreatorsJoinTable < ActiveRecord::Migration[7.2]
  def change
    create_join_table :people, :requests, table_name: :creators do |t|
      # t.index [:person_id, :request_id]
      # t.index [:request_id, :person_id]
    end
  end
end
