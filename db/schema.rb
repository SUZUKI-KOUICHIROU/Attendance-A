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

ActiveRecord::Schema.define(version: 20211230104159) do

  create_table "attendancelogs", force: :cascade do |t|
    t.date "month_form"
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
    t.datetime "before_started_at"
    t.datetime "before_finished_at"
    t.date "approval_day"
    t.string "before_note"
    t.datetime "change_started_at"
    t.datetime "change_finished_at"
    t.integer "first_approval", default: 0
    t.datetime "approval_overtime"
    t.string "approval_contents"
    t.boolean "approval_tomorrow", default: false, null: false
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
    t.boolean "superior", default: false
    t.string "affiliation"
    t.datetime "basic_work_time", default: "2021-12-29 23:00:00"
    t.datetime "work_time", default: "2021-12-29 22:30:00"
    t.datetime "designated_work_start_time", default: "2021-12-30 00:00:00"
    t.datetime "designated_work_end_time", default: "2021-12-30 09:00:00"
    t.integer "employee_number"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["employee_number"], name: "index_users_on_employee_number", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

end
