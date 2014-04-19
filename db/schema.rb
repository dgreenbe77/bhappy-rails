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

ActiveRecord::Schema.define(version: 20140417131248) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "facebook_users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "happiness_logs", force: true do |t|
    t.float    "health",             default: 0.0
    t.float    "wealth",             default: 0.0
    t.float    "culture",            default: 0.0
    t.float    "location",           default: 0.0
    t.float    "spirituality",       default: 0.0
    t.float    "relationship",       default: 0.0
    t.float    "activity",           default: 0.0
    t.float    "passion",            default: 0.0
    t.float    "satisfaction",       default: 0.0
    t.float    "self_view",          default: 0.0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "smile"
    t.string   "image"
    t.text     "main_post",                        null: false
    t.float    "positive",           default: 0.0
    t.float    "negative",           default: 0.0
    t.text     "why_post"
    t.float    "positive_scale"
    t.float    "negative_scale"
    t.float    "happy_scale"
    t.float    "health_scale"
    t.float    "wealth_scale"
    t.float    "culture_scale"
    t.float    "location_scale"
    t.float    "spirituality_scale"
    t.float    "relationship_scale"
    t.float    "activity_scale"
    t.float    "passion_scale"
    t.float    "satisfaction_scale"
    t.float    "self_view_scale"
    t.integer  "happy",              default: 0
    t.string   "address",                          null: false
    t.string   "title",                            null: false
    t.string   "question"
    t.integer  "min_age"
    t.integer  "max_age"
    t.string   "gender"
    t.float    "gender_confidence"
    t.string   "race"
    t.float    "race_confidence"
    t.float    "smile_scale"
  end

  create_table "locations", force: true do |t|
    t.string   "region"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    null: false
  end

  create_table "questions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "positiveq",  null: false
    t.string   "negativeq",  null: false
  end

  add_index "questions", ["negativeq"], name: "index_questions_on_negativeq", unique: true, using: :btree
  add_index "questions", ["positiveq"], name: "index_questions_on_positiveq", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",       null: false
    t.string   "encrypted_password",     default: "",       null: false
    t.string   "role",                   default: "member", null: false
    t.integer  "info_id"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "image"
    t.string   "hometown"
    t.text     "work"
    t.string   "pic_big"
    t.integer  "friend_count"
    t.text     "activities"
    t.text     "affiliations"
    t.string   "birthday"
    t.text     "books"
    t.string   "current_address"
    t.string   "current_location"
    t.text     "education"
    t.text     "interests"
    t.text     "languages"
    t.text     "movies"
    t.text     "music"
    t.string   "political"
    t.text     "profile_blurb"
    t.text     "quotes"
    t.text     "religion"
    t.text     "sports"
    t.text     "tv"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
