class Comment < ApplicationRecord
    belongs_to :post
    has_many :hashtags, as: :tagable
    extend FriendlyId
    friendly_id :comment, use: :slugged
end
