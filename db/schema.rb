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

ActiveRecord::Schema.define(:version=>6871007) do

  create_table "account_secrets"  do |t|
    t.integer  "account_id",    :null=>false
    t.string   "account_name",  :null=>false
    t.string   "password_hash", :null=>false
    t.string   "password_salt", :null=>false
    t.datetime "created_at",    :null=>false
    t.datetime "updated_at",    :null=>false
  end

  #add_index "account_secrets", ["account_id"], name: "sqlite_autoindex_account_secrets_1", unique: true
  #add_index "account_secrets", ["account_name"], name: "sqlite_autoindex_account_secrets_2", unique: true

  create_table "accounts" do |t|
    t.string   "name",                   :null=>false
    t.string   "fullname",               :null=>false
    t.string   "email",                  :null=>false
    t.integer  "nr_logins",  :default=>0, :null=>false
    t.datetime "created_at",             :null=>false
    t.datetime "updated_at",             :null=>false
  end

  #add_index "accounts", ["name"], name: "sqlite_autoindex_accounts_1", unique: true

  create_table "folders" do |t|
    t.integer  "account_id",              :null=>false
    t.string   "name",                    :null=>false
    t.integer  "folder_type", :default=>0, :null=>false
    t.datetime "created_at",              :null=>false
    t.datetime "updated_at",              :null=>false
  end

  create_table "message_statuses" do |t|
    t.string   "name",       :null=>false
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "messages" do |t|
    t.integer  "account_id"
    t.integer  "folder_id"
    t.integer  "from_id",                :null=>false
    t.integer  "to_id",                  :null=>false
    t.string   "subject",                :null=>false
    t.string   "text",                   :null=>false
    t.integer  "status",     :default=>0, :null=>false
    t.datetime "created_at",             :null=>false
    t.datetime "updated_at",             :null=>false
  end

end
