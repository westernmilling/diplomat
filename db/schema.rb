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

ActiveRecord::Schema.define(version: 20150915131152) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "_promiscuous", force: :cascade do |t|
    t.text     "batch"
    t.datetime "at"
  end

  create_table "contacts", force: :cascade do |t|
    t.integer  "entity_id",                            null: false
    t.string   "full_name",                            null: false
    t.string   "title"
    t.string   "email_address"
    t.string   "fax_number"
    t.string   "mobile_number"
    t.string   "phone_number"
    t.integer  "is_active",                default: 1, null: false
    t.string   "uuid",          limit: 32,             null: false
    t.integer  "_v",                       default: 1, null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "location_id"
    t.integer  "entity_id",                                  null: false
    t.integer  "parent_customer_id"
    t.integer  "bill_to_location_id",                        null: false
    t.integer  "ship_to_location_id",                        null: false
    t.integer  "salesperson_id"
    t.integer  "is_active",                      default: 1, null: false
    t.integer  "is_tax_exempt",                  default: 0, null: false
    t.string   "uuid",                limit: 32,             null: false
    t.integer  "_v",                             default: 1, null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "entities", force: :cascade do |t|
    t.string   "cached_long_name", limit: 1024,                     null: false
    t.string   "comments"
    t.string   "display_name",                                      null: false
    t.string   "entity_type",      limit: 32,   default: "company", null: false
    t.string   "federal_tax_id"
    t.integer  "is_active",                     default: 1,         null: false
    t.integer  "is_withholding"
    t.string   "name",                                              null: false
    t.integer  "parent_entity_id"
    t.string   "reference",                                         null: false
    t.string   "tax_number"
    t.string   "tax_state"
    t.string   "ten99_form"
    t.integer  "ten99_print",                   default: 0,         null: false
    t.string   "ten99_type"
    t.datetime "ten99_signed_at"
    t.string   "uuid",             limit: 32,                       null: false
    t.integer  "_v",                            default: 1,         null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "contact_id"
  end

  create_table "integrations", force: :cascade do |t|
    t.string   "name",                        null: false
    t.string   "integration_type",            null: false
    t.string   "address",                     null: false
    t.string   "credentials",                 null: false
    t.string   "uuid",             limit: 32, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "interface_adhesives", force: :cascade do |t|
    t.integer  "organization_id",    null: false
    t.integer  "integration_id",     null: false
    t.integer  "interfaceable_id",   null: false
    t.string   "interfaceable_type", null: false
    t.string   "interface_id",       null: false
    t.integer  "version"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "interface_logs", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "integration_id"
    t.integer  "interfaceable_id",     null: false
    t.string   "interfaceable_type",   null: false
    t.string   "interface_payload"
    t.string   "interface_status"
    t.string   "interface_identifier"
    t.string   "message"
    t.string   "status",               null: false
    t.string   "action",               null: false
    t.integer  "version"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "interface_states", force: :cascade do |t|
    t.integer  "organization_id",                  null: false
    t.integer  "integration_id",                   null: false
    t.integer  "interfaceable_id",                 null: false
    t.string   "interfaceable_type",               null: false
    t.string   "message"
    t.string   "status",                           null: false
    t.string   "action",                           null: false
    t.string   "interface_identifier"
    t.integer  "version"
    t.integer  "count",                default: 1, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "locations", force: :cascade do |t|
    t.integer  "entity_id",                                                           null: false
    t.string   "cached_long_address",                                                 null: false
    t.string   "location_name",                                                       null: false
    t.string   "street_address",                                                      null: false
    t.string   "city",                                                                null: false
    t.string   "region",                                                              null: false
    t.string   "region_code",                                                         null: false
    t.string   "country",                                                             null: false
    t.string   "phone_number",        limit: 32
    t.string   "fax_number",          limit: 32
    t.decimal  "latitude",                       precision: 10, scale: 8
    t.decimal  "longitude",                      precision: 11, scale: 8
    t.integer  "is_active",                                               default: 1, null: false
    t.string   "uuid",                limit: 32,                                      null: false
    t.integer  "_v",                                                      default: 1, null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
  end

  create_table "organization_entities", force: :cascade do |t|
    t.integer  "entity_id",                              null: false
    t.integer  "organization_id",                        null: false
    t.string   "trait",                                  null: false
    t.string   "uuid",            limit: 32,             null: false
    t.integer  "_v",                         default: 1, null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.integer  "is_active",                 default: 1, null: false
    t.string   "name",                                  null: false
    t.string   "uuid",           limit: 32,             null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "_v",                        default: 1
    t.integer  "integration_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "salespeople", force: :cascade do |t|
    t.integer  "entity_id",                         null: false
    t.string   "gender",     limit: 7
    t.integer  "is_active",             default: 1, null: false
    t.string   "uuid",       limit: 32,             null: false
    t.integer  "_v",                    default: 1, null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                               null: false
    t.string   "email",                              null: false
    t.integer  "is_active",              default: 1, null: false
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "remember_created_at"
    t.integer  "failed_attempts",        default: 0, null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "vendors", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "location_id"
    t.integer  "entity_id",                          null: false
    t.integer  "is_active",              default: 1, null: false
    t.string   "uuid",        limit: 32,             null: false
    t.integer  "_v",                     default: 1, null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

end
