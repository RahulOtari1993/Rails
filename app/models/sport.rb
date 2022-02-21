# t.string "name"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false


class Sport < ApplicationRecord
  has_many :posts
  has_many :announcements
end
