# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_211_028_191_806) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'locker_applications', force: :cascade do |t|
    t.integer 'preferred_size'
    t.string 'preferred_general_area'
    t.boolean 'accessible'
    t.string 'semester'
    t.string 'status_at_application'
    t.string 'department_at_application'
    t.bigint 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_locker_applications_on_user_id'
  end

  create_table 'locker_assignments', force: :cascade do |t|
    t.date 'start_date'
    t.date 'expiration_date'
    t.date 'released_date'
    t.string 'notes'
    t.bigint 'locker_application_id'
    t.bigint 'locker_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['locker_application_id'], name: 'index_locker_assignments_on_locker_application_id'
    t.index ['locker_id'], name: 'index_locker_assignments_on_locker_id'
  end

  create_table 'lockers', force: :cascade do |t|
    t.string 'location'
    t.integer 'size'
    t.string 'general_area'
    t.boolean 'accessible'
    t.string 'notes'
    t.string 'combination'
    t.string 'code'
    t.string 'tag'
    t.string 'discs'
    t.string 'clutch'
    t.string 'hubpos'
    t.string 'key_number'
    t.integer 'floor'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'study_room_assignments', force: :cascade do |t|
    t.date 'start_date'
    t.date 'expiration_date'
    t.date 'released_date'
    t.string 'notes'
    t.bigint 'user_id'
    t.bigint 'study_room_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['study_room_id'], name: 'index_study_room_assignments_on_study_room_id'
    t.index ['user_id'], name: 'index_study_room_assignments_on_user_id'
  end

  create_table 'study_rooms', force: :cascade do |t|
    t.string 'location'
    t.string 'general_area'
    t.string 'notes'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'provider', default: 'cas', null: false
    t.string 'uid', null: false
    t.datetime 'remember_created_at'
    t.boolean 'admin', default: false, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['provider'], name: 'index_users_on_provider'
    t.index %w[uid provider], name: 'index_users_on_uid_and_provider', unique: true
    t.index ['uid'], name: 'index_users_on_uid', unique: true
  end

  add_foreign_key 'locker_applications', 'users'
  add_foreign_key 'locker_assignments', 'lockers'
  add_foreign_key 'study_room_assignments', 'study_rooms'
  add_foreign_key 'study_room_assignments', 'users'
end