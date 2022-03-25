class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user  
  #adding friendly id   
  extend FriendlyId
  friendly_id :comment, use: :slugged
end
