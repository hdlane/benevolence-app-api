class CreateProviderDeliveryDates < ActiveRecord::Migration[7.2]
  def change
    create_table :provider_delivery_dates do |t|
      t.integer :delivery_date_id, null: false
      t.integer :provider_id, null: false

      t.timestamps
    end
  end
end
