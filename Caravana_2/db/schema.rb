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

ActiveRecord::Schema.define(:version => 20131001022944) do

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

  create_table "admin_users", :force => true do |t|
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
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "driver_queues", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "no_show",    :default => false
    t.boolean  "can_view",   :default => false
    t.string   "truck"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "driver_queues", ["user_id"], :name => "index_driver_queues_on_user_id"

  create_table "events", :force => true do |t|
    t.string   "title"
    t.datetime "datetime"
    t.string   "address"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "import_id"
    t.boolean  "closed",     :default => true
    t.integer  "server_id"
  end

  add_index "events", ["import_id"], :name => "index_events_on_import_id"

  create_table "imports", :force => true do |t|
    t.integer  "admin_user_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "sync_file_name"
    t.string   "sync_content_type"
    t.integer  "sync_file_size"
    t.datetime "sync_updated_at"
    t.boolean  "parsed",            :default => false, :null => false
  end

  add_index "imports", ["admin_user_id"], :name => "index_imports_on_admin_user_id"

  create_table "midia_attachments", :force => true do |t|
    t.integer  "user_event_confirmation_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "midia_attachments", ["user_event_confirmation_id"], :name => "index_midia_attachments_on_user_event_confirmation_id"

  create_table "premiations", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "delivered",  :default => false
    t.boolean  "can_view",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "premiations", ["user_id"], :name => "index_premiations_on_user_id"

  create_table "reports", :force => true do |t|
    t.string   "what"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "user_event_confirmation_id"
    t.integer  "user_event_id"
  end

  add_index "reports", ["user_event_confirmation_id"], :name => "index_reports_on_user_event_confirmation_id"
  add_index "reports", ["user_event_id"], :name => "index_reports_on_user_event_id"

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.boolean  "ative"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_event_confirmations", :force => true do |t|
    t.integer  "user_event_id"
    t.string   "function"
    t.string   "address"
    t.string   "number"
    t.string   "complement"
    t.string   "cep"
    t.string   "state"
    t.string   "city"
    t.string   "cellnumber"
    t.boolean  "smartphone"
    t.boolean  "sms_usage"
    t.boolean  "email_usage"
    t.boolean  "image_usage"
    t.datetime "qr_sent_at"
    t.string   "qr_path"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "server_id"
  end

  add_index "user_event_confirmations", ["user_event_id"], :name => "index_user_event_confirmations_on_user_event_id"

  create_table "user_events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.string   "status",          :default => "I",   :null => false
    t.string   "token",           :default => "0",   :null => false
    t.boolean  "presence",        :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "qr_code_scanned", :default => false, :null => false
    t.integer  "server_id"
  end

  add_index "user_events", ["event_id"], :name => "index_user_events_on_event_id"
  add_index "user_events", ["user_id"], :name => "index_user_events_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "company"
    t.string   "email"
    t.string   "cep"
    t.string   "address"
    t.string   "state"
    t.string   "city"
    t.string   "cel"
    t.string   "smartphone"
    t.string   "job"
    t.string   "complement"
    t.string   "number"
    t.boolean  "report_not_done", :default => false
    t.boolean  "image_usage"
    t.boolean  "sms_alert"
    t.boolean  "email_alert"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "server_id"
  end

  create_table "whats", :force => true do |t|
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "whats", ["user_id"], :name => "index_whats_on_user_id"

end
