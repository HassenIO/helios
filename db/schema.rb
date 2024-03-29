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

ActiveRecord::Schema.define(:version => 20140203100231) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "air_ports", :force => true do |t|
    t.string "name"
    t.string "city"
    t.string "country"
    t.string "status",  :default => "ON"
  end

  create_table "api_mgts", :force => true do |t|
    t.string   "pickup_date"
    t.string   "pickup_time"
    t.string   "dropoff_date"
    t.string   "dropoff_time"
    t.integer  "airport_id"
    t.integer  "driver_age"
    t.string   "affiliate_id"
    t.integer  "nb_travels"
    t.integer  "nb_days"
    t.integer  "min_price"
    t.integer  "max_price"
    t.text     "response"
    t.string   "token"
    t.boolean  "click",        :default => false
    t.integer  "nb_clicks",    :default => 0
    t.string   "travels"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "cars", :force => true do |t|
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "brand"
    t.string   "model"
    t.integer  "travel_id"
    t.integer  "km"
    t.string   "license"
    t.integer  "year"
    t.integer  "nbSeats"
    t.boolean  "hasGps"
    t.boolean  "hasCarRadio"
    t.boolean  "isSmoker"
    t.boolean  "acceptedPets"
    t.text     "desc"
    t.boolean  "hasChildSeat"
    t.boolean  "hasAirConditioning"
    t.string   "fuel"
    t.string   "filepicker1_url"
    t.string   "filepicker2_url"
    t.string   "filepicker3_url"
    t.integer  "category_id"
    t.string   "transmission"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.float    "price"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "drivers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.string   "zip_code"
    t.string   "phone"
    t.date     "birth_date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "license"
    t.integer  "rent_id"
    t.integer  "license_year"
  end

  create_table "parkings", :force => true do |t|
    t.string   "airport"
    t.string   "pickup"
    t.string   "dropoff"
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "brand"
    t.string   "model"
    t.integer  "year"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "nb_people"
    t.text     "comment"
    t.integer  "price"
    t.boolean  "paid"
    t.string   "status",     :default => "pending"
  end

  create_table "payments", :force => true do |t|
    t.integer "amount"
    t.integer "rent_id"
    t.integer "contribution_id"
    t.text    "contribution_details"
    t.integer "status"
  end

  create_table "rent_options", :force => true do |t|
    t.string   "code"
    t.integer  "price",         :default => 0
    t.boolean  "daily_price",   :default => false
    t.string   "default_label"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "rent_options", ["code"], :name => "index_rent_options_on_code", :unique => true

  create_table "rent_options_rents", :id => false, :force => true do |t|
    t.integer "rent_option_id"
    t.integer "rent_id"
  end

  add_index "rent_options_rents", ["rent_option_id", "rent_id"], :name => "index_rent_options_rents_on_rent_option_id_and_rent_id"

  create_table "rents", :force => true do |t|
    t.datetime "startDate"
    t.datetime "endDate"
    t.integer  "user_id"
    t.integer  "travel_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "airPort_id"
    t.boolean  "has_accepted_cgv"
    t.text     "comments"
    t.string   "status",           :default => "unpaid"
    t.string   "transaction_id"
    t.text     "payment_params"
    t.integer  "amount"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "travels", :force => true do |t|
    t.datetime "departure"
    t.datetime "arrival"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "user_id"
    t.integer  "airPort_id"
    t.integer  "status"
    t.boolean  "has_accepted_cgv"
    t.text     "commercial_text"
    t.datetime "rdv"
    t.string   "flight_n_departure"
    t.string   "flight_n_arrival"
    t.string   "contacted"
    t.string   "reg_document"
    t.integer  "count_person"
    t.string   "phone"
    t.integer  "presence"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "provider"
    t.string   "uid"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.string   "zip_code"
    t.integer  "license_year"
    t.string   "license"
    t.date     "birth_date"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
