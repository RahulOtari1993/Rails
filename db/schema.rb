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

ActiveRecord::Schema.define(version: 2020_07_08_150023) do

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
    t.text "header_description"
    t.float "header_description_font_size"
    t.string "header_description_font_color"
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
    t.integer "domain_type", default: 1, null: false
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
    t.boolean "white_branding", default: false
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
    t.string "caption"
    t.string "icon"
    t.string "success_message"
    t.string "failed_message"
    t.integer "correct_answer_count"
    t.integer "completions", default: 0
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

  create_table "email_settings", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_email_settings_on_campaign_id"
  end

  create_table "global_configurations", force: :cascade do |t|
    t.string "facebook_app_id"
    t.string "facebook_app_secret"
    t.string "google_client_id"
    t.string "google_client_secret"
    t.string "twitter_app_id"
    t.string "twitter_app_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "networks", force: :cascade do |t|
    t.bigint "campaign_id"
    t.integer "platform"
    t.string "auth_token"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_networks_on_campaign_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "description"
    t.bigint "campaign_id"
    t.bigint "user_id"
    t.bigint "participant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_notes_on_campaign_id"
    t.index ["participant_id"], name: "index_notes_on_participant_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
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

  create_table "participant_actions", force: :cascade do |t|
    t.bigint "participant_id"
    t.integer "points"
    t.integer "action_type"
    t.string "title"
    t.string "details"
    t.integer "actionable_id"
    t.string "actionable_type"
    t.text "user_agent"
    t.string "ip_address", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "coupon"
    t.bigint "campaign_id"
    t.index ["campaign_id"], name: "index_participant_actions_on_campaign_id"
    t.index ["participant_id"], name: "index_participant_actions_on_participant_id"
  end

  create_table "participant_device_tokens", force: :cascade do |t|
    t.integer "participant_id"
    t.string "os_type"
    t.string "os_version"
    t.string "device_id"
    t.string "token"
    t.string "token_type"
    t.string "device_arn"
    t.string "app_version"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participant_profiles", force: :cascade do |t|
    t.bigint "participant_id"
    t.bigint "profile_attribute_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_id"], name: "index_participant_profiles_on_participant_id"
    t.index ["profile_attribute_id"], name: "index_participant_profiles_on_profile_attribute_id"
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
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_name"
    t.date "birth_date"
    t.string "gender"
    t.string "phone"
    t.string "city"
    t.string "state"
    t.string "postal"
    t.string "address_1"
    t.string "address_2"
    t.text "bio"
    t.string "p_id"
    t.string "facebook_uid"
    t.string "facebook_token"
    t.datetime "facebook_expires_at"
    t.string "google_uid"
    t.string "google_token"
    t.string "google_refresh_token"
    t.datetime "google_expires_at"
    t.integer "points", default: 0
    t.integer "unused_points", default: 0
    t.integer "clicks", default: 0
    t.integer "likes", default: 0
    t.integer "comments", default: 0
    t.integer "reshares", default: 0
    t.integer "recruits", default: 0
    t.integer "connect_type"
    t.integer "age", default: 0
    t.integer "completed_challenges", default: 0
    t.string "avatar"
    t.integer "status", default: 0
    t.string "twitter_uid"
    t.string "twitter_token"
    t.string "twitter_secret"
    t.string "country"
    t.string "home_phone"
    t.string "work_phone"
    t.string "job_position"
    t.string "job_company_name"
    t.string "job_industry"
    t.integer "email_setting_id"
    t.string "provider", default: "email"
    t.string "uid"
    t.text "tokens"
    t.index ["confirmation_token"], name: "index_participants_on_confirmation_token", unique: true
    t.index ["email", "organization_id", "campaign_id"], name: "index_participant_email_org_campaign", unique: true
    t.index ["email", "organization_id", "campaign_id"], name: "index_participants_on_email_and_organization_id_and_campaign_id", unique: true
    t.index ["reset_password_token"], name: "index_participants_on_reset_password_token", unique: true
    t.index ["uid", "provider", "organization_id", "campaign_id"], name: "index_participant_uid_provider_org_campaign", unique: true
  end

  create_table "profile_attributes", force: :cascade do |t|
    t.bigint "campaign_id"
    t.string "attribute_name"
    t.string "display_name"
    t.integer "field_type"
    t.boolean "is_active", default: true
    t.boolean "is_custom", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_profile_attributes_on_campaign_id"
  end

  create_table "question_options", force: :cascade do |t|
    t.bigint "question_id"
    t.string "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "answer"
    t.integer "sequence"
    t.index ["question_id"], name: "index_question_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "challenge_id"
    t.integer "category"
    t.string "title"
    t.boolean "is_required", default: false
    t.integer "answer_type"
    t.integer "profile_attribute_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "placeholder"
    t.string "additional_details"
    t.integer "sequence"
    t.index ["challenge_id"], name: "index_questions_on_challenge_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "participant_id"
    t.index ["reward_id"], name: "index_reward_participants_on_reward_id"
  end

  create_table "reward_rules", force: :cascade do |t|
    t.string "rule_type"
    t.bigint "reward_id"
    t.string "rule_condition"
    t.string "rule_value"
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
    t.integer "filter_type", default: 0
    t.boolean "filter_applied", default: false
    t.integer "rule_type", default: 0
    t.boolean "rule_applied", default: false
    t.integer "claims", default: 0
    t.boolean "date_range", default: false
    t.index ["campaign_id"], name: "index_rewards_on_campaign_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.bigint "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "participant_id"
    t.bigint "challenge_id"
    t.text "user_agent"
    t.string "ip_address"
    t.index ["campaign_id"], name: "index_submissions_on_campaign_id"
    t.index ["challenge_id"], name: "index_submissions_on_challenge_id"
    t.index ["participant_id"], name: "index_submissions_on_participant_id"
  end

  create_table "submitted_answers", force: :cascade do |t|
    t.bigint "challenge_id"
    t.bigint "question_id"
    t.bigint "participant_id"
    t.bigint "question_option_id"
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_submitted_answers_on_challenge_id"
    t.index ["participant_id"], name: "index_submitted_answers_on_participant_id"
    t.index ["question_id"], name: "index_submitted_answers_on_question_id"
    t.index ["question_option_id"], name: "index_submitted_answers_on_question_option_id"
  end

  create_table "sweepstake_entries", force: :cascade do |t|
    t.bigint "reward_id"
    t.bigint "participant_id"
    t.boolean "winner", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_id"], name: "index_sweepstake_entries_on_participant_id"
    t.index ["reward_id"], name: "index_sweepstake_entries_on_reward_id"
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
  add_foreign_key "challenges", "campaigns"
  add_foreign_key "coupons", "rewards"
  add_foreign_key "domain_lists", "campaigns"
  add_foreign_key "domain_lists", "organizations"
  add_foreign_key "email_settings", "campaigns"
  add_foreign_key "networks", "campaigns"
  add_foreign_key "notes", "campaigns"
  add_foreign_key "notes", "participants"
  add_foreign_key "notes", "users"
  add_foreign_key "participant_actions", "participants"
  add_foreign_key "participant_profiles", "participants"
  add_foreign_key "participant_profiles", "profile_attributes"
  add_foreign_key "profile_attributes", "campaigns"
  add_foreign_key "question_options", "questions"
  add_foreign_key "questions", "challenges"
  add_foreign_key "reward_participants", "rewards"
  add_foreign_key "reward_rules", "rewards"
  add_foreign_key "rewards", "campaigns"
  add_foreign_key "submissions", "campaigns"
  add_foreign_key "submitted_answers", "challenges"
  add_foreign_key "submitted_answers", "participants"
  add_foreign_key "submitted_answers", "question_options"
  add_foreign_key "submitted_answers", "questions"
  add_foreign_key "sweepstake_entries", "participants"
  add_foreign_key "sweepstake_entries", "rewards"
  add_foreign_key "taggings", "tags"
end
