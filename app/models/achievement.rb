class Achievement < ApplicationRecord
  belongs_to :user

  validates :award, :medal, presence: true 
  
  extend FriendlyId
  friendly_id :award, use: :slugged
end
