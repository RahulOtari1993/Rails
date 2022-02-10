class Sport < ApplicationRecord
    has_many :players
    has_many :posts
    validates :sport_name, presence: true
    validates :total_player, presence: true
    validates :total_player, numericality: true

    extend FriendlyId
    friendly_id :sport_name, use: :slugged
end
