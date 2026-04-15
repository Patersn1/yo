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

ActiveRecord::Schema[8.1].define(version: 2026_03_27_172136) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "favorite_opportunities", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "opportunity_id"
    t.integer "tag_id"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["opportunity_id"], name: "index_favorite_opportunities_on_opportunity_id"
    t.index ["user_id"], name: "index_favorite_opportunities_on_user_id"
  end

  create_table "favorite_organizations", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "organization_id"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["organization_id"], name: "index_favorite_organizations_on_organization_id"
    t.index ["user_id"], name: "index_favorite_organizations_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "message"
    t.string "name"
    t.integer "notification_type", default: 0
    t.bigint "opportunity_id"
    t.bigint "organization_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["opportunity_id"], name: "index_notifications_on_opportunity_id"
    t.index ["organization_id"], name: "index_notifications_on_organization_id"
  end

  create_table "opportunities", force: :cascade do |t|
    t.string "address", limit: 100, null: false
    t.boolean "approved", default: false
    t.string "city", limit: 100, null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "description", limit: 500
    t.string "email", limit: 50, null: false
    t.time "end_time"
    t.string "frequency", limit: 50
    t.string "issue_area"
    t.string "name", limit: 50, null: false
    t.date "on_date"
    t.bigint "organization_id", null: false
    t.string "primary_tag_id"
    t.string "secondary_tag_id"
    t.time "start_time"
    t.string "state", limit: 2, null: false
    t.boolean "transportation", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "zip_code", limit: 5, null: false
    t.index ["issue_area"], name: "index_opportunities_on_issue_area"
    t.index ["organization_id"], name: "index_opportunities_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "address", limit: 100
    t.boolean "approved", default: false, null: false
    t.string "city", limit: 100
    t.datetime "created_at", precision: nil, null: false
    t.string "description", limit: 1000
    t.string "email", limit: 50, null: false
    t.string "issue_area", limit: 500
    t.string "name", limit: 75, null: false
    t.string "phone_no", limit: 12, null: false
    t.string "photo"
    t.string "state", limit: 2
    t.integer "tag_id"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id", null: false
    t.string "zip_code", limit: 5
  end

  create_table "photos", force: :cascade do |t|
    t.string "attachment"
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "rides", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "driver_name"
    t.string "opportuniy_id"
    t.string "rider1"
    t.string "rider2"
    t.string "rider3"
    t.string "rider4"
    t.integer "total_seats"
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.boolean "approved", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "academic_year"
    t.boolean "admin", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.string "interest"
    t.datetime "last_sign_in_at", precision: nil
    t.inet "last_sign_in_ip"
    t.datetime "locked_at", precision: nil
    t.string "major"
    t.string "name"
    t.integer "notification_period", default: 7
    t.bigint "organization_id"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.string "school"
    t.integer "sign_in_count", default: 0, null: false
    t.integer "tag_id"
    t.string "transportation_status"
    t.string "unlock_token"
    t.datetime "updated_at", precision: nil, null: false
    t.string "year"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_opportunities_join_tables", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "opportunity_id"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["opportunity_id"], name: "index_users_opportunities_join_tables_on_opportunity_id"
    t.index ["user_id"], name: "index_users_opportunities_join_tables_on_user_id"
  end

  create_table "volunteers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "opportunity_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["opportunity_id"], name: "index_volunteers_on_opportunity_id"
    t.index ["user_id"], name: "index_volunteers_on_user_id"
  end

  add_foreign_key "favorite_opportunities", "opportunities"
  add_foreign_key "favorite_opportunities", "users"
  add_foreign_key "favorite_organizations", "organizations"
  add_foreign_key "favorite_organizations", "users"
  add_foreign_key "opportunities", "organizations"
  add_foreign_key "organizations", "users"
  add_foreign_key "users", "tags"
  add_foreign_key "users_opportunities_join_tables", "opportunities"
  add_foreign_key "users_opportunities_join_tables", "users"
  add_foreign_key "volunteers", "opportunities"
  add_foreign_key "volunteers", "users"
end
