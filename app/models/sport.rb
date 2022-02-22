# t.string "name"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false


class Sport < ApplicationRecord
  #Associated with users,posts and announcements 
  has_many :users
  has_many :posts
  has_many :announcements

  #validation
  validates :name, presence: true  
end
