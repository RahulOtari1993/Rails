# t.string "title"
# t.text "description"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.integer "sport_id"
# t.index ["sport_id"], name: "index_announcements_on_sport_id"


class AnnouncementSerializer < ActiveModel::Serializer
  attributes :id, :title, :description
  
  #Association 
  belongs_to :sport
end
