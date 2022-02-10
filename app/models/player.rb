class Player < ApplicationRecord
    mount_uploader :image, FileUploader
    belongs_to :sport
    has_many :achievements
    has_many :posts
    has_many :tags
    has_many :posts, through: :tags

    validates :image, :player_name, :player_city, :player_country, :phone,:gender, :email, presence: true 
    validates :phone, numericality: true
    validates :phone, length: { is: 10 }
    validates :email, uniqueness: true
    validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

    extend FriendlyId
    friendly_id :player_name, use: :slugged

end
