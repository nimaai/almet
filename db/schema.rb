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

ActiveRecord::Schema.define(version: 20131223160925) do

  create_table "reservations", force: true do |t|
    t.date     "arrival"
    t.date     "departure"
    t.integer  "adults",             default: 1
    t.integer  "visitor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "children",           default: 0
    t.boolean  "bedclothes_service", default: true
  end

  create_table "visitors", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "street"
    t.string   "zip"
    t.string   "city"
    t.string   "country"
    t.string   "phone"
    t.string   "mobile"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
