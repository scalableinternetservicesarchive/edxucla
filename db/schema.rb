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

ActiveRecord::Schema.define(version: 20161201071211) do

  create_table "conversations", force: :cascade do |t|
    t.integer  "user_one"
    t.integer  "user_two"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_one", "user_two"], name: "index_conversations_on_user_one_and_user_two", unique: true
  end

  create_table "course_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "education_id"
    t.string   "education_alias"
    t.string   "course_alias"
    t.string   "course_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "courses", force: :cascade do |t|
    t.integer "education_id"
    t.string  "department"
    t.string  "name"
    t.string  "alias"
  end

  create_table "education_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "education_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "educations", force: :cascade do |t|
    t.string "name"
    t.string "alias"
  end

  create_table "seed_states", force: :cascade do |t|
    t.boolean  "status",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_seed_states_on_status", unique: true
  end

  create_table "session_messages", force: :cascade do |t|
    t.string   "message"
    t.integer  "sender"
    t.integer  "receiver"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tutoring_sessions", force: :cascade do |t|
    t.integer  "tutor"
    t.integer  "student"
    t.integer  "course_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_messages", force: :cascade do |t|
    t.string   "message"
    t.integer  "sender"
    t.integer  "receiver"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "conversation_id"
  end

  create_table "user_requests", force: :cascade do |t|
    t.string   "request_type"
    t.integer  "sender"
    t.integer  "receiver"
    t.integer  "course_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
