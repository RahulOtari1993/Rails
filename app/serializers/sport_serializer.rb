class SportSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :posts
  has_many :announcements
end
