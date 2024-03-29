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

ActiveRecord::Schema.define(version: 20151023173201) do

  create_table "clients", force: :cascade do |t|
    t.string   "client_code"
    t.string   "client_name"
    t.string   "client_address"
    t.string   "client_cep"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.string   "description"
    t.integer  "weight"
    t.integer  "value"
    t.string   "cemaster"
    t.string   "cehouse"
    t.string   "di"
    t.integer  "invoice_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "expenses", ["invoice_id"], name: "index_expenses_on_invoice_id"

  create_table "historics", force: :cascade do |t|
    t.datetime "moment"
    t.string   "user"
    t.string   "historic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "o_id"
  end

  add_index "historics", ["o_id"], name: "index_historics_on_o_id"

  create_table "invoices", force: :cascade do |t|
    t.integer  "invoice_num"
    t.string   "invoice_url"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "service"
    t.string   "emission_date"
    t.string   "due_date"
    t.string   "pay_date"
    t.string   "pay_status"
    t.string   "email"
    t.integer  "invoice_id"
    t.integer  "o_id"
    t.integer  "client_id"
    t.float    "value"
  end

  add_index "invoices", ["client_id"], name: "index_invoices_on_client_id"
  add_index "invoices", ["invoice_id"], name: "index_invoices_on_invoice_id"
  add_index "invoices", ["o_id"], name: "index_invoices_on_o_id"

  create_table "os", force: :cascade do |t|
    t.integer  "os_num"
    t.string   "os_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "client_id"
    t.string   "ce"
    t.string   "di"
    t.datetime "retirada"
    t.float    "cif_value"
    t.float    "total_value"
    t.datetime "created"
    t.integer  "number"
    t.integer  "turn"
  end

  add_index "os", ["client_id"], name: "index_os_on_client_id"

  create_table "services", force: :cascade do |t|
    t.integer  "quantity"
    t.string   "service"
    t.float    "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "o_id"
  end

  add_index "services", ["o_id"], name: "index_services_on_o_id"

end
