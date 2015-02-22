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

ActiveRecord::Schema.define(version: 20150222103040) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "reservations", force: :cascade do |t|
    t.date     "arrival",                              null: false
    t.date     "departure",                            null: false
    t.integer  "adults",             default: 1,       null: false
    t.integer  "visitor_id"
    t.datetime "created_at",         default: "now()", null: false
    t.datetime "updated_at",         default: "now()", null: false
    t.integer  "children",           default: 0,       null: false
    t.boolean  "bedclothes_service", default: true,    null: false
  end

  create_table "visitors", force: :cascade do |t|
    t.string   "firstname",                    null: false
    t.string   "lastname",                     null: false
    t.string   "street",                       null: false
    t.string   "zip",                          null: false
    t.string   "city",                         null: false
    t.string   "country",                      null: false
    t.string   "phone"
    t.string   "mobile"
    t.string   "email",                        null: false
    t.datetime "created_at", default: "now()", null: false
    t.datetime "updated_at", default: "now()", null: false
  end

  add_foreign_key "reservations", "visitors"
end
