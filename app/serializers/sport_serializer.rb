# t.string "name"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false


class SportSerializer < ActiveModel::Serializer
  attributes :id, :name
  
  #Association
  has_many :posts
  has_many :announcements
end
