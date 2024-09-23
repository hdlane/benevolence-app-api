class CreateDeliveryDates < ActiveRecord::Migration[7.2]
  def change
    create_table :delivery_dates do |t|
      t.date :date
      t.integer :request_id, null: false
      t.integer :resource_id, null: false
      t.integer :provider_id, null: false

      t.timestamps
    end
  end
end
