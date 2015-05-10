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

ActiveRecord::Schema.define(version: 20150509154028) do

  create_table "admins", force: true do |t|
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.integer  "sign_in_count",      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",    default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_messages", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facilities", force: true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "address"
    t.string   "phone"
  end

  add_index "facilities", ["owner_id"], name: "index_facilities_on_owner_id"

  create_table "members", force: true do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "email"
    t.boolean  "is_male"
    t.date     "date_of_birth"
    t.string   "occupation"
    t.text     "address"
    t.string   "pincode"
    t.string   "emergency_number"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "facility_id"
    t.boolean  "inactive",         default: false
  end

  add_index "members", ["facility_id"], name: "index_members_on_facility_id"

  create_table "memberships", force: true do |t|
    t.string   "name"
    t.integer  "duration"
    t.decimal  "cost"
    t.integer  "facility_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "duration_type"
    t.integer  "duration_in_days"
  end

  add_index "memberships", ["facility_id"], name: "index_memberships_on_facility_id"

  create_table "owners", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "deactivated"
  end

  add_index "owners", ["email"], name: "index_owners_on_email", unique: true

  create_table "purchases", force: true do |t|
    t.string   "name"
    t.integer  "cost"
    t.date     "date"
    t.string   "purchase_type"
    t.integer  "member_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "purchases", ["member_id"], name: "index_purchases_on_member_id"

  create_table "revenues", force: true do |t|
    t.decimal  "value"
    t.date     "date"
    t.integer  "facility_id"
    t.integer  "member_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "purchasable_id"
    t.string   "purchasable_type"
  end

  add_index "revenues", ["facility_id"], name: "index_revenues_on_facility_id"
  add_index "revenues", ["member_id"], name: "index_revenues_on_member_id"
  add_index "revenues", ["purchasable_id", "purchasable_type"], name: "index_revenues_on_purchasable_id_and_purchasable_type"

  create_table "subscriptions", force: true do |t|
    t.date     "start_date"
    t.integer  "membership_id"
    t.integer  "member_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "subscriptions", ["member_id"], name: "index_subscriptions_on_member_id"
  add_index "subscriptions", ["membership_id"], name: "index_subscriptions_on_membership_id"

end
