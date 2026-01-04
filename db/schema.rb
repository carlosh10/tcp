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

ActiveRecord::Schema[7.2].define(version: 2026_01_04_085844) do
  create_table "countries", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.string "flag_emoji"
    t.integer "visa_limit_days"
    t.integer "visa_period_days"
    t.integer "tax_residency_days", default: 183
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_countries_on_code", unique: true
  end

  create_table "country_rules", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "country_id", null: false
    t.integer "max_days"
    t.integer "period_days"
    t.boolean "alert_enabled", default: true
    t.integer "alert_threshold"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_country_rules_on_country_id"
    t.index ["user_id", "country_id"], name: "index_country_rules_on_user_id_and_country_id", unique: true
    t.index ["user_id"], name: "index_country_rules_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "home_country_code"
    t.string "timezone", default: "UTC"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "country_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.text "notes"
    t.string "purpose"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_visits_on_country_id"
    t.index ["user_id", "start_date", "end_date"], name: "index_visits_on_user_id_and_start_date_and_end_date"
    t.index ["user_id"], name: "index_visits_on_user_id"
  end

  add_foreign_key "country_rules", "countries"
  add_foreign_key "country_rules", "users"
  add_foreign_key "visits", "countries"
  add_foreign_key "visits", "users"
end
