class Hashtag < ApplicationRecord
  belongs_to :tagable, polymorphic: true
end
