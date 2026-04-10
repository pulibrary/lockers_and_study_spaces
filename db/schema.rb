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

ActiveRecord::Schema[8.1].define(version: 2025_04_01_191905) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "buildings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_buildings_on_name", unique: true
  end

  create_table "flipflop_features", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "enabled", default: false, null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locker_applications", force: :cascade do |t|
    t.text "accessibility_needs", default: [], array: true
    t.boolean "accessible"
    t.boolean "archived", default: false
    t.bigint "building_id", default: 1
    t.boolean "complete", default: false
    t.datetime "created_at", precision: nil, null: false
    t.string "department_at_application", limit: 70
    t.string "preferred_general_area"
    t.integer "preferred_size"
    t.string "semester"
    t.string "status_at_application"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["building_id"], name: "index_locker_applications_on_building_id"
    t.index ["user_id"], name: "index_locker_applications_on_user_id"
  end

  create_table "locker_assignments", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.date "expiration_date"
    t.bigint "locker_application_id"
    t.bigint "locker_id"
    t.string "notes"
    t.date "released_date"
    t.date "start_date"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["locker_application_id"], name: "index_locker_assignments_on_locker_application_id"
    t.index ["locker_id"], name: "index_locker_assignments_on_locker_id"
  end

  create_table "locker_violations", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "locker_id"
    t.integer "number_of_books"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
  end

  create_table "lockers", force: :cascade do |t|
    t.boolean "accessible"
    t.bigint "building_id"
    t.string "clutch"
    t.string "code"
    t.string "combination"
    t.datetime "created_at", precision: nil, null: false
    t.boolean "disabled"
    t.string "discs"
    t.string "floor"
    t.string "general_area"
    t.string "hubpos"
    t.string "key_number"
    t.string "location"
    t.string "notes"
    t.integer "size"
    t.string "tag"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "scheduled_messages", force: :cascade do |t|
    t.daterange "applicable_range"
    t.bigint "building_id", default: 1
    t.datetime "created_at", null: false
    t.json "results"
    t.date "schedule"
    t.string "template"
    t.string "type"
    t.datetime "updated_at", null: false
    t.string "user_filter"
    t.index ["building_id"], name: "index_scheduled_messages_on_building_id"
  end

  create_table "study_room_assignments", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.date "expiration_date"
    t.string "notes"
    t.date "released_date"
    t.date "start_date"
    t.bigint "study_room_id"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["study_room_id"], name: "index_study_room_assignments_on_study_room_id"
    t.index ["user_id"], name: "index_study_room_assignments_on_user_id"
  end

  create_table "study_room_violations", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "number_of_books"
    t.integer "study_room_id"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
  end

  create_table "study_rooms", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "general_area"
    t.string "location"
    t.string "notes"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.bigint "building_id"
    t.datetime "created_at", precision: nil, null: false
    t.string "provider", default: "cas", null: false
    t.datetime "remember_created_at", precision: nil
    t.string "uid", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["provider"], name: "index_users_on_provider"
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "locker_applications", "buildings"
  add_foreign_key "locker_applications", "users"
  add_foreign_key "locker_assignments", "lockers"
  add_foreign_key "study_room_assignments", "study_rooms"
  add_foreign_key "study_room_assignments", "users"
end
