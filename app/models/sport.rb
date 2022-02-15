class Sport < ApplicationRecord
  has_many :players
  has_many :sportannouncements
  has_many :posts
  #validations   
  validates :sport_name, presence: true
  validates :total_player, presence: true
  validates :total_player, numericality: true
  #friendly id   
  extend FriendlyId
  friendly_id :sport_name, use: :slugged
end
