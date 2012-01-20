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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120120045033) do

  create_table "classifiers", :force => true do |t|
    t.string   "program_name", :limit => 128, :null => false
    t.text     "synopsis"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "config_vars", :force => true do |t|
    t.string "name",  :null => false
    t.binary "value", :null => false
  end

  add_index "config_vars", ["name"], :name => "index_config_vars_on_name", :unique => true

  create_table "credentials", :force => true do |t|
    t.integer "user_id",                                    :null => false
    t.string  "type",     :limit => 32,                     :null => false
    t.string  "name",     :limit => 128
    t.boolean "verified",                :default => false, :null => false
    t.binary  "key"
  end

  add_index "credentials", ["type", "name"], :name => "index_credentials_on_type_and_name", :unique => true
  add_index "credentials", ["user_id", "type"], :name => "index_credentials_on_user_id_and_type"

  create_table "data", :force => true do |t|
    t.string   "file_name",     :limit => 64,       :null => false
    t.string   "relation_name", :limit => 256,      :null => false
    t.text     "examples",      :limit => 16777215, :null => false
    t.integer  "num_examples",                      :null => false
    t.text     "features",                          :null => false
    t.integer  "num_features",                      :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id", :unique => true

  create_table "projects", :force => true do |t|
    t.string   "name",       :limit => 64, :null => false
    t.integer  "profile_id",               :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "projects", ["profile_id"], :name => "index_projects_on_profile_id"

  create_table "trials", :force => true do |t|
    t.integer  "classifier_id"
    t.integer  "datum_id"
    t.integer  "project_id",                        :null => false
    t.string   "name",          :limit => 32,       :null => false
    t.text     "output",        :limit => 16777215
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "trials", ["project_id"], :name => "index_trials_on_project_id"

  create_table "users", :force => true do |t|
    t.string   "exuid",      :limit => 32, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "users", ["exuid"], :name => "index_users_on_exuid", :unique => true

end
