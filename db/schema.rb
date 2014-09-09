# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140521175627) do

  create_table "churches", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.binary   "picture"
    t.string   "web_site"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "churches", ["user_id"], name: "index_churches_on_user_id"

  create_table "locking_examples", force: true do |t|
    t.string   "name"
    t.integer  "lock_version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rides", force: true do |t|
    t.integer  "user_id"
    t.integer  "service_id"
    t.date     "date"
    t.time     "leave_time"
    t.time     "return_time"
    t.integer  "number_of_seats"
    t.integer  "seats_available"
    t.string   "meeting_location"
    t.text     "vehicle"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rides", ["service_id"], name: "index_rides_on_service_id"
  add_index "rides", ["user_id"], name: "index_rides_on_user_id"

  create_table "services", force: true do |t|
    t.integer  "church_id"
    t.string   "day_of_week"
    t.time     "start_time"
    t.time     "finish_time"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "services", ["church_id"], name: "index_services_on_church_id"

  create_table "user_rides", force: true do |t|
    t.integer  "user_id"
    t.integer  "ride_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_rides", ["ride_id"], name: "index_user_rides_on_ride_id"
  add_index "user_rides", ["user_id"], name: "index_user_rides_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.boolean  "admin",           default: false
    t.integer  "church_id"
    t.string   "phone_number"
    t.binary   "picture"
  end

  add_index "users", ["church_id"], name: "index_users_on_church_id"

end
