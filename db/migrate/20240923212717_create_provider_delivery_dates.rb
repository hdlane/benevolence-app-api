class CreateProviderDeliveryDates < ActiveRecord::Migration[7.2]
  def change
    create_table :provider_delivery_dates do |t|
      t.references :delivery_date, null: false, foreign_key: { on_delete: :cascade }, index: true
      t.references :provider, null: false, foreign_key: { on_delete: :cascade }, index: true

      t.timestamps
    end
    add_index :provider_delivery_dates, [ :delivery_date_id, :provider_id ]
  end
end
