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

ActiveRecord::Schema[7.0].define(version: 2024_09_29_044455) do
  create_table "bookings", force: :cascade do |t|
    t.date "check_in_date"
    t.date "check_out_date"
    t.time "check_in_time"
    t.time "check_out_time"
    t.integer "number_of_rooms"
    t.string "type_of_room"
    t.string "status", default: "pending"
    t.integer "user_id", null: false
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_bookings_on_room_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "hotels", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hotels_users", id: false, force: :cascade do |t|
    t.integer "hotel_id", null: false
    t.integer "user_id", null: false
    t.index ["hotel_id"], name: "index_hotels_users_on_hotel_id"
    t.index ["user_id"], name: "index_hotels_users_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "room_type"
    t.string "features"
    t.string "status", default: "Available"
    t.integer "hotel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rate"
    t.index ["hotel_id"], name: "index_rooms_on_hotel_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "rooms"
  add_foreign_key "bookings", "users"
  add_foreign_key "rooms", "hotels"
end
