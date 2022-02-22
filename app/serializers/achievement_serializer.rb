# t.string "award"
# t.string "medal"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.integer "user_id"

class AchievementSerializer < ActiveModel::Serializer
  attributes :id, :award, :medal
  
  #Association  
  belongs_to :user
end
