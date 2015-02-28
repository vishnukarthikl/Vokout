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

ActiveRecord::Schema.define(version: 20150227103240) do

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "email"
    t.boolean  "is_male"
    t.date     "date_of_birth"
    t.string   "occupation"
    t.text     "address"
    t.string   "pincode"
    t.string   "emergency_number"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "facility_id"
  end

  add_index "customers", ["facility_id"], name: "index_customers_on_facility_id"

  create_table "customers_memberships", id: false, force: true do |t|
    t.integer "customer_id"
    t.integer "membership_id"
  end

  add_index "customers_memberships", ["customer_id"], name: "index_customers_memberships_on_customer_id"
  add_index "customers_memberships", ["membership_id"], name: "index_customers_memberships_on_membership_id"

  create_table "facilities", force: true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "address"
    t.string   "phone"
  end

  add_index "facilities", ["owner_id"], name: "index_facilities_on_owner_id"

  create_table "memberships", force: true do |t|
    t.string   "name"
    t.integer  "duration"
    t.decimal  "cost"
    t.integer  "facility_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "memberships", ["facility_id"], name: "index_memberships_on_facility_id"

  create_table "owners", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "owners", ["email"], name: "index_owners_on_email", unique: true

end
