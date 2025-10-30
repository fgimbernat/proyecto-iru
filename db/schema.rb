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

ActiveRecord::Schema[7.2].define(version: 2025_10_30_233610) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "area_id", null: false
    t.bigint "hierarchy_id", null: false
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_employee_segmentations_on_area_id"
    t.index ["employee_id"], name: "index_employee_segmentations_on_employee_id"
    t.index ["hierarchy_id"], name: "index_employee_segmentations_on_hierarchy_id"
    t.index ["location_id"], name: "index_employee_segmentations_on_location_id"
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
    t.index ["department_id"], name: "index_employees_on_department_id"
    t.index ["document_number"], name: "index_employees_on_document_number", unique: true
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["employee_number"], name: "index_employees_on_employee_number", unique: true
    t.index ["employment_status"], name: "index_employees_on_employment_status"
    t.index ["manager_id"], name: "index_employees_on_manager_id"
    t.index ["position_id"], name: "index_employees_on_position_id"
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "hierarchies", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "employee_segmentations", "areas"
  add_foreign_key "employee_segmentations", "employees"
  add_foreign_key "employee_segmentations", "hierarchies"
  add_foreign_key "employee_segmentations", "locations"
  add_foreign_key "employees", "departments"
  add_foreign_key "employees", "positions"
  add_foreign_key "employees", "users"
  add_foreign_key "positions", "departments"
end
