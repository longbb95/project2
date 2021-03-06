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

ActiveRecord::Schema.define(version: 20160513040814) do

  create_table "comments", force: :cascade do |t|
    t.string   "content"
    t.integer  "member_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["member_id"], name: "index_comments_on_member_id"
  add_index "comments", ["post_id"], name: "index_comments_on_post_id"

  create_table "members", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "activation_digest"
    t.string   "status"
    t.string   "role"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "notification"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "post_id"
    t.string   "content"
    t.string   "status"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "commentator_id"
  end

  add_index "notifications", ["post_id"], name: "index_notifications_on_post_id"

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.string   "content"
    t.integer  "member_id"
    t.integer  "topic_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "status"
    t.integer  "last_comment_id"
    t.datetime "last_comment_at"
    t.integer  "number_views"
  end

  add_index "posts", ["member_id"], name: "index_posts_on_member_id"
  add_index "posts", ["topic_id"], name: "index_posts_on_topic_id"

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
  end

end
