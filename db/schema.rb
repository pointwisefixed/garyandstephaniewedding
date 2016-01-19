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

ActiveRecord::Schema.define(version: 20160118232407) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "entrees", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "order"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "guests", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "county"
    t.string   "zipcode"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
    t.boolean  "attending"
    t.boolean  "plusone"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "address1"
    t.text     "address2"
    t.string   "zipcode"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "username"
    t.string   "plus_one_first_name"
    t.string   "plust_one_last_name"
    t.integer  "entree_id"
    t.integer  "plus_one_entree_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["entree_id"], name: "index_users_on_entree_id"
  add_index "users", ["plus_one_entree_id"], name: "index_users_on_plus_one_entree_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

  create_table "wedding_infos", force: :cascade do |t|
    t.text     "hisInformation"
    t.text     "herInformation"
    t.text     "ourStory"
    t.text     "ourFirstMeeting"
    t.text     "ourFirstDate"
    t.text     "proposal"
    t.text     "theRing"
    t.text     "whenAndWhereIsTheWedding"
    t.text     "ceremony"
    t.text     "reception"
    t.text     "accomodations"
    t.text     "attending"
    t.text     "ourGallery"
    t.text     "dontMissIt"
    t.text     "moreEvents"
    t.text     "dancingParty"
    t.text     "flowerAndFlowers"
    t.text     "groomsmen"
    t.text     "bestFriend"
    t.text     "bridesmaid"
    t.text     "maidOfHonor"
    t.text     "bestMan"
    t.text     "bestBrideFriend"
    t.text     "giftRegistry"
    t.text     "rsvpInfo"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

end
