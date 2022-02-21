class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :tag
  belongs_to :sport
end
