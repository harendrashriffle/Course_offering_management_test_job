# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_02_29_144502) do
  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "content"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "instructor_assignee_courses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_instructor_assignee_courses_on_course_id"
    t.index ["user_id"], name: "index_instructor_assignee_courses_on_user_id"
  end

  create_table "student_enroll_courses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_student_enroll_courses_on_course_id"
    t.index ["user_id"], name: "index_student_enroll_courses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "contact"
    t.string "email"
    t.string "password_digest"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "courses", "users"
  add_foreign_key "instructor_assignee_courses", "courses"
  add_foreign_key "instructor_assignee_courses", "users"
  add_foreign_key "student_enroll_courses", "courses"
  add_foreign_key "student_enroll_courses", "users"
end
