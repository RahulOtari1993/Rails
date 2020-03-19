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

ActiveRecord::Schema.define(version: 2020_03_19_145319) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "first_name"
    t.string "last_name"
    t.boolean "is_active", default: true, null: false
    t.boolean "is_deleted", default: false, null: false
    t.integer "deleted_by"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "campaigns", force: :cascade do |t|
    t.bigint "organization_id"
    t.string "name"
    t.string "domain"
    t.string "twitter"
    t.text "rules"
    t.text "privacy"
    t.text "terms"
    t.text "contact_us"
    t.string "faq_title"
    t.text "faq_content"
    t.string "prizes_title"
    t.text "general_content"
    t.string "how_to_earn_title"
    t.text "how_to_earn_content"
    t.text "css"
    t.text "seo"
    t.boolean "is_active"
    t.text "template"
    t.boolean "templated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_campaigns_on_organization_id"
  end

  create_table "challenges", force: :cascade do |t|
    t.bigint "campaign_id"
    t.text "name"
    t.integer "platform_id"
    t.datetime "start"
    t.datetime "finish"
    t.string "timezone"
    t.integer "points"
    t.string "parameters"
    t.string "mechanism"
    t.boolean "feature"
    t.integer "creator_id"
    t.integer "approver_id"
    t.text "content"
    t.text "link"
    t.integer "clicks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_challenges_on_campaign_id"
  end

  create_table "organization_admins", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organization_admins_on_organization_id"
    t.index ["user_id"], name: "index_organization_admins_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.string "sub_domain", null: false
    t.bigint "admin_user_id", null: false
    t.boolean "is_active", default: true, null: false
    t.boolean "is_deleted", default: false, null: false
    t.integer "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_organizations_on_admin_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "first_name"
    t.string "last_name"
    t.boolean "is_active", default: true, null: false
    t.boolean "is_deleted", default: false, null: false
    t.integer "deleted_by"
    t.integer "organization_id"
    t.integer "role"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "is_invited", default: false
    t.integer "invited_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "organization_id"], name: "index_users_on_email_and_organization_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "campaigns", "organizations"
  add_foreign_key "challenges", "campaigns"
end
