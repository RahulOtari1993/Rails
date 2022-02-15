class Player < ApplicationRecord
  mount_uploader :image, FileUploader
  belongs_to :sport
  belongs_to :user
  has_many :tags
  has_many :posts, through: :tags
  #validations   
  validates :image, :player_name, :player_city, :player_country, :phone,:gender, :email, presence: true 
  validates :phone, numericality: true
  validates :phone, length: { is: 10 }
  validates :email, uniqueness: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  #friendly id
  extend FriendlyId
  friendly_id :player_name, use: :slugged
end
