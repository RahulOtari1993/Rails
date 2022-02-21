class AnnouncementSerializer < ActiveModel::Serializer
  attributes :id, :title, :description
  belongs_to :sport
end
