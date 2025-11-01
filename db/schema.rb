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

ActiveRecord::Schema[7.2].define(version: 2025_11_01_000004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "visibility", default: "all"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "manager_id"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_departments_on_manager_id"
    t.index ["name"], name: "index_departments_on_name"
  end

  create_table "employee_segmentations", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "segmentation_item_id"
    t.index ["employee_id"], name: "index_employee_segmentations_on_employee_id"
    t.index ["segmentation_item_id"], name: "index_employee_segmentations_on_segmentation_item_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "employee_number", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.integer "document_type", default: 0, null: false
    t.string "document_number", null: false
    t.date "birth_date"
    t.integer "gender"
    t.integer "marital_status"
    t.string "email", null: false
    t.string "phone"
    t.string "mobile"
    t.text "address"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country", default: "Argentina"
    t.date "hire_date", null: false
    t.date "termination_date"
    t.integer "employment_status", default: 0, null: false
    t.integer "employment_type", default: 0, null: false
    t.bigint "position_id", null: false
    t.bigint "department_id", null: false
    t.integer "manager_id"
    t.decimal "salary", precision: 10, scale: 2
    t.string "currency", default: "ARS"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "middle_name"
    t.string "linkedin"
    t.string "instagram"
    t.string "facebook"
    t.string "twitter"
    t.string "education"
    t.string "position_title"
    t.string "civil_status"
    t.string "languages"
    t.string "lives_in"
    t.decimal "salary_2023"
    t.decimal "salary_2024"
    t.string "emergency_contact"
    t.text "books"
    t.string "team"
    t.bigint "office_id"
    t.index ["department_id"], name: "index_employees_on_department_id"
    t.index ["document_number"], name: "index_employees_on_document_number", unique: true
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["employee_number"], name: "index_employees_on_employee_number", unique: true
    t.index ["employment_status"], name: "index_employees_on_employment_status"
    t.index ["manager_id"], name: "index_employees_on_manager_id"
    t.index ["office_id"], name: "index_employees_on_office_id"
    t.index ["position_id"], name: "index_employees_on_position_id"
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "hierarchies", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "visibility", default: "all"
  end

  create_table "holidays", force: :cascade do |t|
    t.string "name", null: false
    t.date "date", null: false
    t.bigint "region_id", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_holidays_on_active"
    t.index ["date"], name: "index_holidays_on_date"
    t.index ["region_id", "date"], name: "index_holidays_on_region_id_and_date", unique: true
    t.index ["region_id"], name: "index_holidays_on_region_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "visibility", default: "all"
  end

  create_table "offices", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "address"
    t.bigint "region_id", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_offices_on_active"
    t.index ["name"], name: "index_offices_on_name"
    t.index ["region_id", "name"], name: "index_offices_on_region_id_and_name", unique: true
    t.index ["region_id"], name: "index_offices_on_region_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "department_id", null: false
    t.integer "level"
    t.decimal "salary_range_min"
    t.decimal "salary_range_max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_positions_on_department_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_regions_on_active"
    t.index ["name"], name: "index_regions_on_name", unique: true
  end

  create_table "segmentation_items", force: :cascade do |t|
    t.string "name"
    t.bigint "segmentation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["segmentation_id"], name: "index_segmentation_items_on_segmentation_id"
  end

  create_table "segmentations", force: :cascade do |t|
    t.string "name"
    t.string "visibility"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_system", default: false, null: false
    t.index ["is_system"], name: "index_segmentations_on_is_system"
  end

  create_table "time_off_policies", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "policy_type", default: 0, null: false
    t.integer "days_per_year"
    t.boolean "requires_approval", default: true
    t.boolean "active", default: true
    t.string "icon"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_time_off_policies_on_active"
    t.index ["policy_type"], name: "index_time_off_policies_on_policy_type"
  end

  create_table "time_off_requests", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "time_off_policy_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "days_requested", null: false
    t.text "reason"
    t.integer "status", default: 0, null: false
    t.bigint "approved_by_id"
    t.datetime "approved_at"
    t.text "approval_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_time_off_requests_on_approved_by_id"
    t.index ["employee_id", "status"], name: "index_time_off_requests_on_employee_id_and_status"
    t.index ["employee_id"], name: "index_time_off_requests_on_employee_id"
    t.index ["start_date"], name: "index_time_off_requests_on_start_date"
    t.index ["status"], name: "index_time_off_requests_on_status"
    t.index ["time_off_policy_id"], name: "index_time_off_requests_on_time_off_policy_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pin_code"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "employee_segmentations", "employees"
  add_foreign_key "employee_segmentations", "segmentation_items"
  add_foreign_key "employees", "departments"
  add_foreign_key "employees", "offices"
  add_foreign_key "employees", "positions"
  add_foreign_key "employees", "users"
  add_foreign_key "holidays", "regions"
  add_foreign_key "offices", "regions"
  add_foreign_key "positions", "departments"
  add_foreign_key "segmentation_items", "segmentations"
  add_foreign_key "time_off_requests", "employees"
  add_foreign_key "time_off_requests", "time_off_policies"
  add_foreign_key "time_off_requests", "users", column: "approved_by_id"
end
