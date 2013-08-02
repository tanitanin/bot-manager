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

ActiveRecord::Schema.define(version: 20130801140251) do

  create_table "bot_auth_tokens", force: true do |t|
    t.integer  "bot_id",          null: false
    t.integer  "bot_consumer_id", null: false
    t.string   "token",           null: false
    t.string   "secret",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bot_consumers", force: true do |t|
    t.integer  "user_id",                    null: false
    t.string   "provider",                   null: false
    t.string   "name",                       null: false
    t.string   "key",                        null: false
    t.string   "secret",                     null: false
    t.boolean  "is_default", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bot_streams", force: true do |t|
    t.integer  "bot_id"
    t.string   "type"
    t.text     "stream"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bots", force: true do |t|
    t.integer  "user_id",           null: false
    t.integer  "bot_auth_token_id"
    t.string   "uid",               null: false
    t.string   "provider",          null: false
    t.string   "name"
    t.string   "nickname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "daemons", force: true do |t|
    t.integer  "bot_id",     null: false
    t.string   "command"
    t.string   "proc_name"
    t.text     "proc_args"
    t.integer  "pid",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "uid"
    t.string   "provider"
    t.string   "image_url"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
