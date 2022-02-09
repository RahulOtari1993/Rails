class Comment < ApplicationRecord
    belongs_to :post
    has_many :hashtags, as: :tagable
end
