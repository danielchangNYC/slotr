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

ActiveRecord::Schema.define(version: 20141203044749) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "interview_interviewers", force: true do |t|
    t.integer "interview_id"
    t.integer "interviewer_id"
  end

  add_index "interview_interviewers", ["interview_id"], name: "index_interview_interviewers_on_interview_id", using: :btree

  create_table "interviews", force: true do |t|
    t.integer  "scheduler_id"
    t.integer  "interviewee_id"
    t.datetime "preferred_datetime_top"
    t.datetime "preferred_datetime_middle"
    t.datetime "preferred_datetime_bottom"
    t.datetime "begins_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interviews", ["interviewee_id"], name: "index_interviews_on_interviewee_id", using: :btree
  add_index "interviews", ["scheduler_id"], name: "index_interviews_on_scheduler_id", using: :btree

  create_table "possible_interview_blocks", force: true do |t|
    t.integer  "interview_id"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  add_index "possible_interview_blocks", ["interview_id"], name: "index_possible_interview_blocks_on_interview_id", using: :btree

  create_table "profiles", force: true do |t|
    t.integer "user_id"
    t.time    "preferred_ends_at"
    t.time    "preferred_begins_at"
    t.boolean "prefer_mon"
    t.boolean "prefer_tues"
    t.boolean "prefer_wed"
    t.boolean "prefer_thurs"
    t.boolean "prefer_fri"
    t.boolean "prefer_sat"
    t.boolean "prefer_sun"
  end

  create_table "rejected_interview_blocks", force: true do |t|
    t.integer  "interview_id"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  add_index "rejected_interview_blocks", ["interview_id"], name: "index_rejected_interview_blocks_on_interview_id", using: :btree

  create_table "rejected_user_blocks", force: true do |t|
    t.integer  "user_id"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  add_index "rejected_user_blocks", ["user_id"], name: "index_rejected_user_blocks_on_user_id", using: :btree

  create_table "schedule_responses", force: true do |t|
    t.integer  "interview_id"
    t.integer  "user_id"
    t.datetime "responded_on"
    t.string   "code"
  end

  add_index "schedule_responses", ["interview_id"], name: "index_schedule_responses_on_interview_id", using: :btree
  add_index "schedule_responses", ["user_id"], name: "index_schedule_responses_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.string   "uid"
    t.string   "provider"
    t.string   "refresh_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
