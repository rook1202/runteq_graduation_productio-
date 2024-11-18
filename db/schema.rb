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

ActiveRecord::Schema[7.0].define(version: 20_241_031_051_545) do
  create_table 'active_storage_attachments', charset: 'utf8mb3', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', charset: 'utf8mb3', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum'
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', charset: 'utf8mb3', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'foods', charset: 'utf8mb3', force: :cascade do |t|
    t.bigint 'partner_id'
    t.string 'manufacturer'
    t.string 'category'
    t.string 'amount'
    t.string 'place'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.text 'note'
    t.index ['partner_id'], name: 'index_foods_on_partner_id'
  end

  create_table 'medications', charset: 'utf8mb3', force: :cascade do |t|
    t.bigint 'partner_id'
    t.string 'name'
    t.string 'place'
    t.string 'clinic'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.text 'note'
    t.string 'amount'
    t.index ['partner_id'], name: 'index_medications_on_partner_id'
  end

  create_table 'partners', charset: 'utf8mb3', force: :cascade do |t|
    t.bigint 'owner_id'
    t.string 'name', null: false
    t.integer 'gender', default: 0, null: false
    t.date 'birthday'
    t.string 'weight'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'animal_type', null: false
    t.string 'breed'
    t.index ['owner_id'], name: 'index_partners_on_owner_id'
  end

  create_table 'remainders', charset: 'utf8mb3', force: :cascade do |t|
    t.bigint 'partner_id'
    t.string 'time'
    t.boolean 'notification_status', default: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'activity_type'
    t.bigint 'activity_id'
    t.index %w[activity_type activity_id], name: 'index_remainders_on_activity_type_and_activity_id'
    t.index ['partner_id'], name: 'index_remainders_on_partner_id'
  end

  create_table 'sessions', charset: 'utf8mb3', force: :cascade do |t|
    t.bigint 'user_id'
    t.string 'activity_type'
    t.datetime 'login_time'
    t.string 'ip_address'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_sessions_on_user_id'
  end

  create_table 'users', charset: 'utf8mb3', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'email', null: false
    t.string 'crypted_password'
    t.string 'salt'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
  end

  create_table 'walks', charset: 'utf8mb3', force: :cascade do |t|
    t.bigint 'partner_id'
    t.string 'time'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.text 'note'
    t.index ['partner_id'], name: 'index_walks_on_partner_id'
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'foods', 'partners'
  add_foreign_key 'medications', 'partners'
  add_foreign_key 'partners', 'users', column: 'owner_id'
  add_foreign_key 'remainders', 'partners'
  add_foreign_key 'sessions', 'users'
  add_foreign_key 'walks', 'partners'
end
