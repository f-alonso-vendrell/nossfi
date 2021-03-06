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

ActiveRecord::Schema.define(version: 20160312222828) do

  create_table "admins", force: true do |t|
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "audits", force: true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index"
  add_index "audits", ["created_at"], name: "index_audits_on_created_at"
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid"
  add_index "audits", ["user_id", "user_type"], name: "user_index"

  create_table "filters", force: true do |t|
    t.string   "name"
    t.integer  "template"
    t.text     "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forms", force: true do |t|
    t.integer  "template_id"
    t.integer  "creator"
    t.string   "recipients"
    t.boolean  "private"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "data",        limit: 255
  end

  create_table "groupers", force: true do |t|
    t.string   "name"
    t.integer  "template"
    t.text     "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", force: true do |t|
    t.integer  "template_report_id"
    t.integer  "creator"
    t.text     "data"
    t.text     "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "template_reports", force: true do |t|
    t.string   "title"
    t.string   "desc"
    t.string   "fields"
    t.string   "data"
    t.integer  "creator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "templates", force: true do |t|
    t.string   "title"
    t.string   "desc"
    t.integer  "templateVersion"
    t.text     "fields",          limit: 255
    t.boolean  "aprovable"
    t.boolean  "acknowledgeable"
    t.string   "defaultemail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent"
    t.integer  "childtemplates"
    t.integer  "childforms"
    t.integer  "creator"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.text     "preferences"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
