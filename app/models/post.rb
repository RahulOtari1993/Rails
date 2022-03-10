# t.string "title"
# t.text "description"
# t.string "tag"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.integer "sport_id"
# t.index ["sport_id"], name: "index_posts_on_sport_id"


class Post < ApplicationRecord
  #Association with sport
  belongs_to :sport

  #validation
  validates :title, presence: true
  validates :description, presence: true
  # validates :tag, presence: true
end
