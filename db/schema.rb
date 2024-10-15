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

ActiveRecord::Schema[7.0].define(version: 2024_10_14_071944) do
  create_table "foods", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "partner_id"
    t.string "manufacturer"
    t.string "category"
    t.string "amount"
    t.string "place"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["partner_id"], name: "index_foods_on_partner_id"
  end

  create_table "medications", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "partner_id"
    t.string "name"
    t.string "place"
    t.string "clinic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["partner_id"], name: "index_medications_on_partner_id"
  end

  create_table "partners", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "owner_id"
    t.string "name", null: false
    t.integer "gender"
    t.date "birthday"
    t.string "weight"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_partners_on_owner_id"
  end

  create_table "remainders", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "partner_id"
    t.string "activity_type"
    t.datetime "time"
    t.boolean "notification_status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["partner_id"], name: "index_remainders_on_partner_id"
  end

  create_table "sessions", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id"
    t.string "activity_type"
    t.datetime "login_time"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "walks", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "partner_id"
    t.integer "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["partner_id"], name: "index_walks_on_partner_id"
  end

  add_foreign_key "foods", "partners"
  add_foreign_key "medications", "partners"
  add_foreign_key "partners", "users", column: "owner_id"
  add_foreign_key "remainders", "partners"
  add_foreign_key "sessions", "users"
  add_foreign_key "walks", "partners"
end
