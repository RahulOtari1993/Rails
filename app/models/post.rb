class Post < ApplicationRecord
  mount_uploader :image, FileUploader
  belongs_to :user    
  has_many :comments
  has_many :hashtags, as: :tagable
  #validaiton 
  validates :title,  :description,  presence: true 
  #friendly id
  extend FriendlyId
  friendly_id :title, use: :slugged
end
