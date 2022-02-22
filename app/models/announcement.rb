# t.string "title"
# t.text "description"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.integer "sport_id"
# t.index ["sport_id"], name: "index_announcements_on_sport_id"


class Announcement < ApplicationRecord
  #Association With Sport
  belongs_to :sport

  #validation
  validates :title, presence: true
  validates :description, presence: true  
end
