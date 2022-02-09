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

ActiveRecord::Schema.define(version: 2022_02_09_132251) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.string "award"
    t.string "medal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_id"
    t.string "player"
    t.index ["player_id"], name: "index_achievements_on_player_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "comment"
    t.string "post"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "post_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "hashtags", force: :cascade do |t|
    t.string "tagable_type"
    t.bigint "tagable_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tagable_type", "tagable_id"], name: "index_hashtags_on_tagable_type_and_tagable_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "player_name"
    t.string "player_city"
    t.string "player_state"
    t.string "player_country"
    t.string "phone"
    t.string "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "game_name"
    t.integer "sport_id"
    t.string "image"
    t.string "email"
    t.index ["sport_id"], name: "index_players_on_sport_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "playerName"
    t.integer "player_id"
    t.string "sport"
    t.integer "sport_id"
    t.string "image"
    t.index ["player_id"], name: "index_posts_on_player_id"
    t.index ["sport_id"], name: "index_posts_on_sport_id"
  end

  create_table "sports", force: :cascade do |t|
    t.string "sport_name"
    t.bigint "total_player"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
