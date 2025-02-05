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

ActiveRecord::Schema[8.0].define(version: 2025_02_05_184800) do
  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string "content"
    t.integer "suggestion_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["suggestion_id"], name: "index_comments_on_suggestion_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "replies", force: :cascade do |t|
    t.string "content"
    t.integer "user_id", null: false
    t.integer "comment_id", null: false
    t.string "replying_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_replies_on_comment_id"
    t.index ["user_id"], name: "index_replies_on_user_id"
  end

  create_table "suggestions", force: :cascade do |t|
    t.string "title"
    t.string "status"
    t.string "description"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id", null: false
    t.index ["category_id"], name: "index_suggestions_on_category_id"
    t.index ["user_id"], name: "index_suggestions_on_user_id"
  end

  create_table "upvotes", force: :cascade do |t|
    t.integer "suggestion_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["suggestion_id"], name: "index_upvotes_on_suggestion_id"
    t.index ["user_id"], name: "index_upvotes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "profile_picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "comments", "suggestions"
  add_foreign_key "comments", "users"
  add_foreign_key "replies", "comments"
  add_foreign_key "replies", "users"
  add_foreign_key "suggestions", "categories"
  add_foreign_key "suggestions", "users"
  add_foreign_key "upvotes", "suggestions"
  add_foreign_key "upvotes", "users"
end
