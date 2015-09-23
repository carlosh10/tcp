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

ActiveRecord::Schema.define(version: 20150923195848) do

  create_table "appearances", force: :cascade do |t|
    t.integer  "invoice_id"
    t.integer  "o_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "appearances", ["invoice_id"], name: "index_appearances_on_invoice_id"
  add_index "appearances", ["o_id"], name: "index_appearances_on_o_id"

  create_table "clients", force: :cascade do |t|
    t.string   "client_code"
    t.string   "client_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "invoice_num"
    t.string   "invoice_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "os", force: :cascade do |t|
    t.integer  "os_num"
    t.string   "os_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
