# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_10_02_045320) do
  create_table "coordinators", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "request_id", null: false
  end

  create_table "creators", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "request_id", null: false
  end

  create_table "delivery_dates", force: :cascade do |t|
    t.integer "request_id", null: false
    t.integer "resource_id", null: false
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_delivery_dates_on_request_id"
    t.index ["resource_id"], name: "index_delivery_dates_on_resource_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.string "access_token"
    t.string "refresh_token"
    t.integer "token_expires_at"
    t.datetime "synced_at"
    t.bigint "pco_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_organizations_on_access_token", unique: true
    t.index ["name"], name: "index_organizations_on_name"
    t.index ["pco_id"], name: "index_organizations_on_pco_id", unique: true
    t.index ["refresh_token"], name: "index_organizations_on_refresh_token", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "name", null: false
    t.string "email"
    t.string "phone_number"
    t.boolean "is_admin", null: false
    t.integer "pco_person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_people_on_email"
    t.index ["organization_id"], name: "index_people_on_organization_id"
    t.index ["pco_person_id"], name: "index_people_on_pco_person_id", unique: true
    t.index ["phone_number"], name: "index_people_on_phone_number"
  end

  create_table "provider_delivery_dates", force: :cascade do |t|
    t.integer "delivery_date_id", null: false
    t.integer "provider_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_date_id", "provider_id"], name: "idx_on_delivery_date_id_provider_id_bc339a1704"
    t.index ["delivery_date_id"], name: "index_provider_delivery_dates_on_delivery_date_id"
    t.index ["provider_id"], name: "index_provider_delivery_dates_on_provider_id"
  end

  create_table "providers", force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "resource_id", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_providers_on_person_id"
    t.index ["resource_id"], name: "index_providers_on_resource_id"
  end

  create_table "recipients", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "request_id", null: false
  end

  create_table "requests", force: :cascade do |t|
    t.integer "recipient_id", null: false
    t.integer "coordinator_id", null: false
    t.integer "creator_id", null: false
    t.integer "organization_id", null: false
    t.string "request_type", null: false
    t.string "title", null: false
    t.text "notes"
    t.text "allergies"
    t.date "start_date", null: false
    t.time "start_time"
    t.date "end_date"
    t.time "end_time"
    t.string "street_line"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coordinator_id"], name: "index_requests_on_coordinator_id"
    t.index ["creator_id"], name: "index_requests_on_creator_id"
    t.index ["organization_id", "recipient_id", "coordinator_id", "creator_id"], name: "idx_on_organization_id_recipient_id_coordinator_id__8eea8b6e81"
    t.index ["organization_id"], name: "index_requests_on_organization_id"
    t.index ["recipient_id"], name: "index_requests_on_recipient_id"
  end

  create_table "resources", force: :cascade do |t|
    t.integer "request_id", null: false
    t.integer "organization_id", null: false
    t.string "name"
    t.string "kind", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_resources_on_organization_id"
    t.index ["request_id"], name: "index_resources_on_request_id"
  end

  add_foreign_key "delivery_dates", "requests", on_delete: :cascade
  add_foreign_key "delivery_dates", "resources", on_delete: :cascade
  add_foreign_key "people", "organizations", on_delete: :cascade
  add_foreign_key "provider_delivery_dates", "delivery_dates", on_delete: :cascade
  add_foreign_key "provider_delivery_dates", "providers", on_delete: :cascade
  add_foreign_key "providers", "people", on_delete: :cascade
  add_foreign_key "providers", "resources", on_delete: :cascade
  add_foreign_key "requests", "organizations", on_delete: :cascade
  add_foreign_key "resources", "organizations", on_delete: :cascade
  add_foreign_key "resources", "requests", on_delete: :cascade
end
