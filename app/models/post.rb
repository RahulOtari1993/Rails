class Post < ApplicationRecord
    mount_uploader :image, FileUploader
    has_many :comments
    belongs_to :player
    belongs_to :sport
    has_many :hashtags, as: :tagable
     
    validates :title,  :description,  presence: true 

    extend FriendlyId
    friendly_id :title, use: :slugged
end
