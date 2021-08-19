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

ActiveRecord::Schema.define(version: 20210818232905) do

  create_table "attendance_logs", force: :cascade do |t|
    t.date "month_select"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "month_check_superior"
    t.string "month_status"
    t.date "apply_month"
    t.boolean "status_change", default: false, null: false
    t.datetime "plans_endtime"
    t.string "business_contents"
    t.boolean "next_day", default: false, null: false
    t.string "superior_confirmation"
    t.boolean "overwork_change", default: false, null: false
    t.string "worktime_check_superior"
    t.boolean "tomorrow", default: false, null: false
    t.boolean "worktime_change", default: false, null: false
    t.integer "worktime_approval", default: 0, null: false
    t.integer "overwork_status", default: 0, null: false
    t.date "date_form"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.integer "base_number"
    t.string "base_name"
    t.string "attendance_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.datetime "basic_time", default: "2021-05-21 23:00:00"
    t.datetime "work_time", default: "2021-05-21 22:30:00"
    t.boolean "superior", default: false
    t.string "belong"
    t.integer "employee_number"
    t.integer "card_id"
    t.datetime "designated_starttime", default: "2021-05-22 00:00:00"
    t.datetime "designated_endtime", default: "2021-05-22 09:00:00"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
