class CreateDeliveryDates < ActiveRecord::Migration[7.2]
  def change
    create_table :delivery_dates do |t|
      t.references :request, null: false, foreign_key: { on_delete: :cascade }, index: true
      t.references :resource, null: false, foreign_key: { on_delete: :cascade }, index: true
      t.date :date

      t.timestamps
    end
  end
end
