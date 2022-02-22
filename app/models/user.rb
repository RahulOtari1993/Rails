# t.string "provider", default: "email", null: false
# t.string "uid", default: "", null: false
# t.string "encrypted_password", default: "", null: false
# t.string "reset_password_token"
# t.datetime "reset_password_sent_at"
# t.boolean "allow_password_change", default: false
# t.datetime "remember_created_at"
# t.string "confirmation_token"
# t.datetime "confirmed_at"
# t.datetime "confirmation_sent_at"
# t.string "unconfirmed_email"
# t.string "name"
# t.string "nickname"
# t.string "image"
# t.string "email"
# t.json "tokens"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.integer "role", default: 0
# t.integer "sport_id"
# t.integer "phone"
# t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
# t.index ["email"], name: "index_users_on_email", unique: true
# t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
# t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true

# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models
 # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  
  # Listing Of Roles
  enum role: [:user, :admin]

  # Association
  has_many :achievements
end
