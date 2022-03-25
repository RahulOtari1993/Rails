class Post < ApplicationRecord
  mount_uploader :image, FileUploader
  belongs_to :user    
  belongs_to :sport
  has_many :comments
  
  #validaiton 
  validates :title, :description,  presence: true 
  #friendly id
  extend FriendlyId
  friendly_id :title, use: :slugged
end
