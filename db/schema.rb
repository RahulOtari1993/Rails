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

ActiveRecord::Schema.define(version: 2020_05_14_075109) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

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

  create_table "campaign_configs", force: :cascade do |t|
    t.bigint "campaign_id"
    t.string "facebook_app_id"
    t.string "facebook_app_secret"
    t.string "google_client_id"
    t.string "google_client_secret"
    t.string "twitter_app_id"
    t.string "twitter_app_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_configs_on_campaign_id"
  end

  create_table "campaign_template_details", force: :cascade do |t|
    t.bigint "campaign_id"
    t.string "favicon_file"
    t.string "footer_background_color"
    t.string "footer_font_color"
    t.float "footer_font_size"
    t.string "header_background_image"
    t.string "header_logo"
    t.string "header_text"
    t.string "header_font_color"
    t.float "header_font_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_template_details_on_campaign_id"
  end

  create_table "campaign_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "campaign_id"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_users_on_campaign_id"
    t.index ["user_id"], name: "index_campaign_users_on_user_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.bigint "organization_id"
    t.string "name", null: false
    t.string "domain", null: false
    t.integer "domain_type", null: false
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
    t.boolean "is_active", default: true
    t.text "template"
    t.boolean "templated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "general_title"
    t.string "my_account_title"
    t.index ["organization_id"], name: "index_campaigns_on_organization_id"
  end

  create_table "campaigns_participants", force: :cascade do |t|
    t.bigint "campaign_id"
    t.bigint "participant_id"
    t.index ["campaign_id"], name: "index_campaigns_participants_on_campaign_id"
    t.index ["participant_id"], name: "index_campaigns_participants_on_participant_id"
  end

  create_table "challenge_filters", force: :cascade do |t|
    t.bigint "challenge_id"
    t.string "challenge_event"
    t.string "challenge_condition"
    t.string "challenge_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_challenge_filters_on_challenge_id"
  end

  create_table "challenge_participants", force: :cascade do |t|
    t.bigint "challenge_id"
    t.bigint "participant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_challenge_participants_on_challenge_id"
    t.index ["participant_id"], name: "index_challenge_participants_on_participant_id"
  end

  create_table "challenges", force: :cascade do |t|
    t.bigint "campaign_id"
    t.text "name"
    t.datetime "start"
    t.datetime "finish"
    t.string "timezone"
    t.integer "points"
    t.string "challenge_type"
    t.boolean "feature"
    t.integer "creator_id"
    t.integer "approver_id"
    t.text "content"
    t.text "link"
    t.integer "clicks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "reward_type"
    t.bigint "reward_id"
    t.boolean "is_approved", default: false
    t.string "image"
    t.string "social_title"
    t.string "social_description"
    t.string "social_image"
    t.integer "login_count"
    t.string "title"
    t.string "points_click"
    t.string "points_maximum"
    t.integer "duration"
    t.integer "parameters"
    t.integer "category"
    t.string "address"
    t.float "longitude"
    t.float "latitude"
    t.integer "location_distance"
    t.integer "filter_type", default: 0
    t.boolean "filter_applied", default: false
    t.index ["campaign_id"], name: "index_challenges_on_campaign_id"
  end

  create_table "coupons", force: :cascade do |t|
    t.bigint "reward_id"
    t.integer "reward_participant_id"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reward_id"], name: "index_coupons_on_reward_id"
  end

  create_table "domain_lists", force: :cascade do |t|
    t.string "domain"
    t.bigint "organization_id"
    t.bigint "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id", "organization_id"], name: "index_domain_lists_on_campaign_id_and_organization_id", unique: true
    t.index ["campaign_id"], name: "index_domain_lists_on_campaign_id"
    t.index ["domain"], name: "index_domain_lists_on_domain", unique: true
    t.index ["organization_id"], name: "index_domain_lists_on_organization_id"
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

  create_table "participant_account_connects", force: :cascade do |t|
    t.bigint "participant_id"
    t.string "email"
    t.string "token"
    t.string "platform"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_id"], name: "index_participant_account_connects_on_participant_id"
  end

  create_table "participants", force: :cascade do |t|
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
    t.boolean "is_active", default: false, null: false
    t.boolean "is_deleted", default: false, null: false
    t.integer "deleted_by"
    t.integer "organization_id"
    t.integer "campaign_id"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "organization_id"], name: "index_participants_on_email_and_organization_id", unique: true
    t.index ["reset_password_token"], name: "index_participants_on_reset_password_token", unique: true
  end

  create_table "reward_filters", force: :cascade do |t|
    t.bigint "reward_id"
    t.string "reward_condition"
    t.string "reward_value"
    t.string "reward_event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reward_id"], name: "index_reward_filters_on_reward_id"
  end

  create_table "reward_participants", force: :cascade do |t|
    t.bigint "reward_id"
    t.bigint "user_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reward_id"], name: "index_reward_participants_on_reward_id"
    t.index ["user_id"], name: "index_reward_participants_on_user_id"
  end

  create_table "reward_rules", force: :cascade do |t|
    t.string "type"
    t.bigint "reward_id"
    t.string "condition"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reward_id"], name: "index_reward_rules_on_reward_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.bigint "campaign_id"
    t.string "name"
    t.integer "limit"
    t.integer "threshold"
    t.text "description"
    t.string "image_file_name"
    t.decimal "image_file_size"
    t.string "image_content_type"
    t.string "selection"
    t.datetime "start"
    t.datetime "finish"
    t.boolean "feature"
    t.integer "points"
    t.boolean "is_active"
    t.text "redemption_details"
    t.text "description_details"
    t.text "terms_conditions"
    t.integer "sweepstake_entry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.text "notes"
    t.integer "msrp_value"
    t.integer "bonus_points"
    t.text "photo_url"
    t.text "thumb_url"
    t.text "actual_image_url"
    t.integer "image_width"
    t.integer "image_height"
    t.index ["campaign_id"], name: "index_rewards_on_campaign_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "campaign_id"
    t.integer "submissible_id"
    t.string "submissible_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_submissions_on_campaign_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
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
    t.boolean "is_active", default: false, null: false
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "campaign_configs", "campaigns"
  add_foreign_key "campaign_template_details", "campaigns"
  add_foreign_key "campaign_users", "campaigns"
  add_foreign_key "campaign_users", "users"
  add_foreign_key "campaigns", "organizations"
  add_foreign_key "challenge_participants", "challenges"
  add_foreign_key "challenge_participants", "participants"
  add_foreign_key "challenges", "campaigns"
  add_foreign_key "coupons", "rewards"
  add_foreign_key "domain_lists", "campaigns"
  add_foreign_key "domain_lists", "organizations"
  add_foreign_key "reward_participants", "rewards"
  add_foreign_key "reward_participants", "users"
  add_foreign_key "reward_rules", "rewards"
  add_foreign_key "rewards", "campaigns"
  add_foreign_key "submissions", "campaigns"
  add_foreign_key "submissions", "users"
  add_foreign_key "taggings", "tags"
end
