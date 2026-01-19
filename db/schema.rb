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

ActiveRecord::Schema[8.1].define(version: 2026_01_19_192727) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "business_employees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.uuid "business_id", null: false
    t.datetime "created_at", null: false
    t.uuid "employee_id", null: false
    t.boolean "primary_location", default: false, null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["business_id", "employee_id"], name: "index_business_employees_on_business_id_and_employee_id", unique: true
    t.index ["business_id"], name: "index_business_employees_on_business_id"
    t.index ["employee_id", "primary_location"], name: "index_business_employees_on_employee_primary", where: "(primary_location = true)"
    t.index ["employee_id"], name: "index_business_employees_on_employee_id"
  end

  create_table "businesses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "active"
    t.datetime "created_at", null: false
    t.string "name"
    t.uuid "organization_id"
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_businesses_on_organization_id"
  end

  create_table "clients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "active"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "employees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "bio"
    t.uuid "business_id"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_employees_on_business_id"
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["role"], name: "index_employees_on_role"
  end

  create_table "locations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.bigint "locatable_id", null: false
    t.string "locatable_type", null: false
    t.integer "location_type", default: 0
    t.string "postal_code"
    t.string "state"
    t.string "street"
    t.string "street2"
    t.datetime "updated_at", null: false
    t.index ["locatable_type", "locatable_id"], name: "index_locations_on_locatable"
  end

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.uuid "owner_id", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_organizations_on_name"
    t.index ["owner_id"], name: "index_organizations_on_owner_id"
  end

  create_table "phones", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "extension"
    t.string "number", null: false
    t.integer "phone_type", default: 0
    t.bigint "phoneable_id", null: false
    t.string "phoneable_type", null: false
    t.datetime "updated_at", null: false
    t.index ["phoneable_type", "phoneable_id"], name: "index_phones_on_phoneable"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "stock_quantity"
    t.uuid "supplier_id"
    t.datetime "updated_at", null: false
    t.text "usage"
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "services", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "business_id"
    t.string "business_type"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_type", "business_id"], name: "index_services_on_business"
  end

  create_table "suppliers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "contact"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "business_employees", "businesses"
  add_foreign_key "business_employees", "employees"
  add_foreign_key "businesses", "organizations"
  add_foreign_key "employees", "businesses"
  add_foreign_key "organizations", "employees", column: "owner_id"
  add_foreign_key "products", "suppliers"
end
