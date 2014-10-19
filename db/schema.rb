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

ActiveRecord::Schema.define(version: 20141019175248) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "name",       null: false
    t.string   "slug",       null: false
    t.integer  "wall_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["slug"], name: "index_accounts_on_slug", unique: true, using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "images", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "image_path", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.integer  "account_id",      null: false
    t.string   "email",           null: false
    t.string   "invitation_code", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["account_id", "email"], name: "index_invitations_on_account_id_and_email", unique: true, using: :btree
  add_index "invitations", ["account_id"], name: "index_invitations_on_account_id", using: :btree
  add_index "invitations", ["invitation_code"], name: "index_invitations_on_invitation_code", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.integer  "wall_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "last_image_id"
    t.string   "type",           null: false
    t.string   "github_user_id"
    t.string   "status_message"
    t.string   "email"
  end

  add_index "users", ["github_user_id"], name: "index_users_on_github_user_id", unique: true, using: :btree

  create_table "walls", force: true do |t|
    t.string   "access_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "walls", ["access_code"], name: "index_walls_on_access_code", unique: true, using: :btree

end
