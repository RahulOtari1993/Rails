# t.string "title"
# t.text "description"
# t.string "tag"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.integer "sport_id"
# t.index ["sport_id"], name: "index_posts_on_sport_id"


class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :tag
  
  #Association
  belongs_to :sport
end
